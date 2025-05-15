import { MigrationInterface, QueryRunner } from "typeorm";

export class Migrations1742870520137 implements MigrationInterface {
    name = 'Migrations1742870520137'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "user" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "name" character varying NOT NULL, "email" character varying NOT NULL, "password" character varying NOT NULL, "profile_image" character varying, CONSTRAINT "UQ_e12875dfb3b1d92d7d7c5377e22" UNIQUE ("email"), CONSTRAINT "PK_cace4a159ff9f2512dd42373760" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "terms_of_agreement" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "content" character varying NOT NULL, CONSTRAINT "PK_c4ce882313f35a2e610311986c7" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "accepted_terms" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "user_id" uuid, "terms_of_agreement_id" uuid, CONSTRAINT "UQ_b9298a5bc56596bfdf80c96829a" UNIQUE ("user_id", "terms_of_agreement_id"), CONSTRAINT "PK_e07cb569af342a223ea99185644" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "code" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "created_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), "code" character varying NOT NULL, "type" character varying NOT NULL, "is_used" boolean NOT NULL DEFAULT false, "last_tried" TIMESTAMP NOT NULL DEFAULT now(), "num_tries" integer NOT NULL DEFAULT '0', "user_id" uuid, CONSTRAINT "PK_367e70f79a9106b8e802e1a9825" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "accepted_terms" ADD CONSTRAINT "FK_64d34e76e75a88182d377e1b876" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "accepted_terms" ADD CONSTRAINT "FK_8f24327efac2b84a1145790e5fe" FOREIGN KEY ("terms_of_agreement_id") REFERENCES "terms_of_agreement"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "code" ADD CONSTRAINT "FK_2c4a681bc6a5fa9f5d4149f86bf" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "code" DROP CONSTRAINT "FK_2c4a681bc6a5fa9f5d4149f86bf"`);
        await queryRunner.query(`ALTER TABLE "accepted_terms" DROP CONSTRAINT "FK_8f24327efac2b84a1145790e5fe"`);
        await queryRunner.query(`ALTER TABLE "accepted_terms" DROP CONSTRAINT "FK_64d34e76e75a88182d377e1b876"`);
        await queryRunner.query(`DROP TABLE "code"`);
        await queryRunner.query(`DROP TABLE "accepted_terms"`);
        await queryRunner.query(`DROP TABLE "terms_of_agreement"`);
        await queryRunner.query(`DROP TABLE "user"`);
    }

}
