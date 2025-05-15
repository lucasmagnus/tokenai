import { MigrationInterface, QueryRunner } from "typeorm";

export class Migrations1744272054705 implements MigrationInterface {
    name = 'Migrations1744272054705'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "asset" DROP COLUMN "total_supply"`);
        await queryRunner.query(`ALTER TABLE "asset" ADD "authorization_required" boolean NOT NULL DEFAULT false`);
        await queryRunner.query(`ALTER TABLE "asset" ADD "authorization_revocable" boolean NOT NULL DEFAULT false`);
        await queryRunner.query(`ALTER TABLE "asset" ADD "clawback_enabled" boolean NOT NULL DEFAULT false`);
        await queryRunner.query(`ALTER TABLE "asset" ADD "authorization_immutable" boolean NOT NULL DEFAULT false`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "asset" DROP COLUMN "authorization_immutable"`);
        await queryRunner.query(`ALTER TABLE "asset" DROP COLUMN "clawback_enabled"`);
        await queryRunner.query(`ALTER TABLE "asset" DROP COLUMN "authorization_revocable"`);
        await queryRunner.query(`ALTER TABLE "asset" DROP COLUMN "authorization_required"`);
        await queryRunner.query(`ALTER TABLE "asset" ADD "total_supply" character varying NOT NULL`);
    }

}
