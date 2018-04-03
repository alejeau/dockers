drop schema if exists `computer-database-db`;
  create schema if not exists `computer-database-db`;
  use `computer-database-db`;

  drop table if exists computer;
  drop table if exists company;

  create table company (
    company_id                        bigint not null auto_increment,
    company_name                      varchar(255),
    constraint pk_company primary key (company_id))
  ;

  create table computer (
    computer_id                        bigint not null auto_increment,
    computer_name                      varchar(255),
    computer_introduced                datetime NULL,
    computer_discontinued              datetime NULL,
    computer_company_id                bigint default NULL,
    constraint pk_computer primary key (computer_id))
  ;

  alter table computer add constraint fk_computer_company_1 foreign key (computer_company_id) references company (company_id) on delete restrict on update restrict;
  create index ix_computer_company_1 on computer (computer_company_id);
