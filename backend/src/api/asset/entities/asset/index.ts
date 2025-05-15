import { Column, Entity, ModelBase, SerializeProps } from "api/core/framework/orm";

@Entity()
export class Asset extends ModelBase {

  @Column()
  code: string;

  @Column()
  issuerWallet: string;

  @Column({ default: false })
  authorizationRequired: boolean;

  @Column({ default: false })
  authorizationRevocable: boolean;

  @Column({ default: false })
  clawbackEnabled: boolean;

  @Column({ default: false })
  authorizationImmutable: boolean;

  serialize(extraProps?: SerializeProps): SerializeProps {
    return {
      code: this.code,
      issuerWallet: this.issuerWallet,
      authorizationRequired: this.authorizationRequired,
      authorizationRevocable: this.authorizationRevocable,
      clawbackEnabled: this.clawbackEnabled,
      authorizationImmutable: this.authorizationImmutable,
      ...super.serialize(extraProps),
    }
  }
}
