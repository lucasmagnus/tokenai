import { validate } from 'class-validator'
import {
  BaseEntity,
  BeforeInsert,
  Column,
  CreateDateColumn,
  Entity,
  FindOneOptions,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
  Repository,
  Unique,
  UpdateDateColumn,
} from 'typeorm'

import { BadRequestException } from 'errors/exceptions/bad-request'
import { ResourceNotFoundException } from 'errors/exceptions/resource-not-found'

export type SerializeProps = { [key: string]: unknown }

abstract class ModelBase extends BaseEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string

  @CreateDateColumn()
  createdAt: Date

  @UpdateDateColumn()
  updatedAt: Date

  /**
   *
   * Serialize the instance to fit a JSON object
   *
   * @param extraProps - Extra serialized props
   * @returns an Object that fits a JSON object
   */
  serialize(extraProps?: SerializeProps): SerializeProps {
    return {
      id: this.id,
      created_at: this.createdAt.toISOString(),
      updated_at: this.updatedAt.toISOString(),
      ...(extraProps ?? {}),
    }
  }

  /**
   *
   * Validates the current instance using class-validator.
   *
   * @throws {ValidationError} - If the instance contains validation errors.
   */
  async validate<T extends ModelBase>(): Promise<void> {
    const errors = await validate(this)
    if (errors.length > 0) {
      const base = this.constructor as { new (): T } & typeof ModelBase
      throw base.validationError()
    }
  }

  /**
   *
   * Saves the current instance to the database after validation.
   *
   * @returns - The saved instance
   */
  async save(): Promise<this> {
    await this.validate()
    return super.save()
  }

  /**
   *
   * Load relations to the current instance
   *
   * @param relations - The relations to load.
   * @returns - A promise that resolves with the updated instance including the loaded relations.
   *
   */
  async loadRelations<T extends ModelBase>(this: T, relations: FindOneOptions<T>['relations']): Promise<T> {
    const base = this.constructor as { new (): T } & typeof ModelBase
    const updatedEntity = await base.findByIdOrFail(this.id, { relations })
    return base.merge(this, updatedEntity) as T
  }

  /**
   * Finds an instance by its ID.
   *
   * @param id - The ID of the instance to find.
   * @param extraOptions - Additional options for the find operation.
   * @returns - A promise that resolves with the found instance or null if not found.
   */
  static async findById<T extends ModelBase>(
    this: { new (): T } & typeof ModelBase,
    id: string,
    extraOptions?: FindOneOptions<T>
  ): Promise<T | null> {
    const where = { ...(extraOptions?.where ?? {}), id }
    const options = { ...(extraOptions ?? {}), where } as FindOneOptions<T>
    return this.findOne<T>(options)
  }

  /**
   * Finds an instance by its ID or throws an error if not found.
   *
   * @param id - The ID of the instance to find.
   * @param extraOptions - Additional options for the find operation.
   * @returns - A promise that resolves with the found instance.
   * @throws {ResourceNotFoundException} - If the instance is not found.
   */
  static async findByIdOrFail<T extends ModelBase>(
    this: { new (): T } & typeof ModelBase,
    id: string,
    extraOptions?: FindOneOptions<T>
  ): Promise<T> {
    const instance = await this.findById<T>(id, extraOptions)
    if (!instance) {
      throw this.notFoundError()
    }
    return instance
  }

  /**
   * Deletes an instance by its ID or throws an error if not found.
   *
   * @param id - The ID of the instance to delete.
   * @returns - A promise that resolves when the instance is deleted.
   * @throws {ResourceNotFoundException} - If the instance is not found.
   */
  static async deleteByIdOrFail<T extends ModelBase>(
    this: { new (): T } & typeof ModelBase,
    id: string
  ): Promise<void> {
    const instance = await this.findByIdOrFail(id)
    await this.delete(instance.id)
  }

  /**
   * Creates a ResourceNotFoundException for the current model.
   *
   * @param message - An optional custom error message.
   * @returns {ResourceNotFoundException} - The created exception.
   */
  static notFoundError<T extends ModelBase>(
    this: {
      new (): T
    } & typeof ModelBase,
    message?: string
  ): ResourceNotFoundException {
    return new ResourceNotFoundException(message ?? `The resource was not found ${this.getRepository().metadata.name}`)
  }

  /**
   * Creates a BadRequestException for the current model.
   *
   * @param message - An optional custom error message.
   * @returns {BadRequestException} - The created exception.
   */
  static validationError<T extends ModelBase>(
    this: {
      new (): T
    } & typeof ModelBase,
    message?: string
  ): BadRequestException {
    return new BadRequestException(message ?? `The resource is invalid ${this.getRepository().metadata.name}`)
  }
}

export {
  ModelBase,
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  BaseEntity,
  Repository,
  BeforeInsert,
  FindOneOptions,
  OneToMany,
  Unique,
  ManyToOne,
  JoinColumn,
}
