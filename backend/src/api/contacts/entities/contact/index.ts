import { Column, Entity, ModelBase, SerializeProps } from "api/core/framework/orm";

@Entity()
export class Contact extends ModelBase {
  
  @Column()
  name: string;

  @Column()
  wallet: string;

  @Column()
  userWallet: string;

  serialize(extraProps?: SerializeProps): SerializeProps {
    return {
      name: this.name,
      wallet: this.wallet,
      userWallet: this.userWallet,
      ...super.serialize(extraProps),
    }
  }
} 