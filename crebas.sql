/*==============================================================*/
/* DBMS name:      PostgreSQL 9.x                               */
/* Created on:     30.10.2017 11:35:36                          */
/*==============================================================*/

drop index FLIEGT_FK CASCADE;

drop index ABFLUG_PK CASCADE;

drop table ABFLUG CASCADE;

drop index RELATIONSHIP_8_FK CASCADE;

drop index BUCHEN_PK CASCADE;

drop table BUCHEN CASCADE;

drop index FLUGHAFEN_PK CASCADE;

drop table FLUGHAFEN CASCADE;

drop index NACH_FK CASCADE;

drop index VON_FK CASCADE;

drop index BEDIENT_FK CASCADE;

drop index FLUGVERBINDUNG__PK CASCADE;

drop table FLUGVERBINDUNG_ CASCADE;

drop index FLUGZEUG_PK CASCADE;

drop table FLUGZEUG CASCADE;

drop index PASSAGIERE_PK CASCADE;

drop table PASSAGIERE CASCADE;

drop index WARTET_FK CASCADE;

drop table WARTUNG CASCADE;

/*==============================================================*/
/* Table: ABFLUG                                                */
/*==============================================================*/
create table ABFLUG (
   AB_DATUM             DATE                 not null,
   FLUGNUMMER           VARCHAR(20)          not null,
   constraint PK_ABFLUG primary key (AB_DATUM, FLUGNUMMER)
);

/*==============================================================*/
/* Index: ABFLUG_PK                                             */
/*==============================================================*/
create unique index ABFLUG_PK on ABFLUG (
AB_DATUM,
FLUGNUMMER
);

/*==============================================================*/
/* Index: FLIEGT_FK                                             */
/*==============================================================*/
create  index FLIEGT_FK on ABFLUG (
FLUGNUMMER
);

/*==============================================================*/
/* Table: BUCHEN                                                */
/*==============================================================*/
create table BUCHEN (
   KUNDENNUMMER         INT4                 not null,
   AB_DATUM             DATE                 not null,
   FLUGNUMMER           VARCHAR(20)          not null,
   PREIS                DECIMAL(10,10)       null,
   constraint PK_BUCHEN primary key (KUNDENNUMMER, AB_DATUM, FLUGNUMMER)
);

/*==============================================================*/
/* Index: BUCHEN_PK                                             */
/*==============================================================*/
create unique index BUCHEN_PK on BUCHEN (
KUNDENNUMMER,
AB_DATUM,
FLUGNUMMER
);

/*==============================================================*/
/* Index: RELATIONSHIP_8_FK                                     */
/*==============================================================*/
create  index RELATIONSHIP_8_FK on BUCHEN (
AB_DATUM,
FLUGNUMMER
);

/*==============================================================*/
/* Table: FLUGHAFEN                                             */
/*==============================================================*/
create table FLUGHAFEN (
   IATA_CODE            VARCHAR(20)          not null,
   NAME                 VARCHAR(60)          null,
   P_LAENGENGRAD        FLOAT10              null,
   P_BREITENGRAD        FLOAT10              null,
   constraint PK_FLUGHAFEN primary key (IATA_CODE)
);

/*==============================================================*/
/* Index: FLUGHAFEN_PK                                          */
/*==============================================================*/
create unique index FLUGHAFEN_PK on FLUGHAFEN (
IATA_CODE
);

/*==============================================================*/
/* Table: FLUGVERBINDUNG_                                       */
/*==============================================================*/
create table FLUGVERBINDUNG_ (
   FLUGNUMMER           VARCHAR(20)          not null,
   IATA_CODES           VARCHAR(20)          null,
   IATA_CODEZ           VARCHAR(20)          null,
   ID                   VARCHAR(20)          not null,
   constraint PK_FLUGVERBINDUNG_ primary key (FLUGNUMMER)
);

/*==============================================================*/
/* Index: FLUGVERBINDUNG__PK                                    */
/*==============================================================*/
create unique index FLUGVERBINDUNG__PK on FLUGVERBINDUNG_ (
FLUGNUMMER
);

/*==============================================================*/
/* Index: BEDIENT_FK                                            */
/*==============================================================*/
create  index BEDIENT_FK on FLUGVERBINDUNG_ (
ID
);

/*==============================================================*/
/* Index: VON_FK                                                */
/*==============================================================*/
create  index VON_FK on FLUGVERBINDUNG_ (
IATA_CODEZ
);

/*==============================================================*/
/* Index: NACH_FK                                               */
/*==============================================================*/
create  index NACH_FK on FLUGVERBINDUNG_ (
IATA_CODES
);

/*==============================================================*/
/* Table: FLUGZEUG                                              */
/*==============================================================*/
create table FLUGZEUG (
   ID                   VARCHAR(20)          not null,
   TYP                  VARCHAR(20)          null,
   ANZAHL_SITZPLAETZE   INT4                 null,
   constraint PK_FLUGZEUG primary key (ID)
);

/*==============================================================*/
/* Index: FLUGZEUG_PK                                           */
/*==============================================================*/
create unique index FLUGZEUG_PK on FLUGZEUG (
ID
);

/*==============================================================*/
/* Table: PASSAGIERE                                            */
/*==============================================================*/
create table PASSAGIERE (
   KUNDENNUMMER         INT4                 not null,
   NACHNAME             VARCHAR(20)          null,
   P_NAME               VARCHAR(20)          null,
   BONUSMEILENKONTO_    DECIMAL(10,10)       null,
   constraint PK_PASSAGIERE primary key (KUNDENNUMMER)
);

/*==============================================================*/
/* Index: PASSAGIERE_PK                                         */
/*==============================================================*/
create unique index PASSAGIERE_PK on PASSAGIERE (
KUNDENNUMMER
);

/*==============================================================*/
/* Table: WARTUNG                                               */
/*==============================================================*/
create table WARTUNG (
   ID                   VARCHAR(20)          not null,
   DATUM                DATE                 not null,
   FLUGFREIGABE         BOOL                 null,
   constraint PK_WARTUNG primary key (ID, DATUM)
);

/*==============================================================*/
/* Index: WARTET_FK                                             */
/*==============================================================*/
create  index WARTET_FK on WARTUNG (
ID
);

alter table ABFLUG
   add constraint FK_ABFLUG_FLIEGT_FLUGVERB foreign key (FLUGNUMMER)
      references FLUGVERBINDUNG_ (FLUGNUMMER)
      on delete restrict on update restrict;

alter table BUCHEN
   add constraint FK_BUCHEN_RELATIONS_PASSAGIE foreign key (KUNDENNUMMER)
      references PASSAGIERE (KUNDENNUMMER)
      on delete restrict on update restrict;

alter table BUCHEN
   add constraint FK_BUCHEN_RELATIONS_ABFLUG foreign key (AB_DATUM, FLUGNUMMER)
      references ABFLUG (AB_DATUM, FLUGNUMMER)
      on delete restrict on update restrict;

alter table FLUGVERBINDUNG_
   add constraint FK_FLUGVERB_BEDIENT_FLUGZEUG foreign key (ID)
      references FLUGZEUG (ID)
      on delete restrict on update restrict;

alter table FLUGVERBINDUNG_
   add constraint FK_FLUGVERB_NACH_FLUGHAFE foreign key (IATA_CODES)
      references FLUGHAFEN (IATA_CODE)
      on delete restrict on update restrict;

alter table FLUGVERBINDUNG_
   add constraint FK_FLUGVERB_VON_FLUGHAFE foreign key (IATA_CODEZ)
      references FLUGHAFEN (IATA_CODE)
      on delete restrict on update restrict;

alter table WARTUNG
   add constraint FK_WARTUNG_WARTET_FLUGZEUG foreign key (ID)
      references FLUGZEUG (ID)
      on delete restrict on update restrict;

/*Auf4*/
DELETE FROM WARTUNG;
DELETE FROM PASSAGIERE;
DELETE FROM FLUGZEUG;
DELETE FROM FLUGVERBINDUNG_;
DELETE FROM FLUGHAFEN;
DELETE FROM BUCHEN;
DELETE FROM ABFLUG;
/*Auf3b*/

/*Auf3a*/
INSERT INTO FLUGHAFEN(NAME, IATA_CODE, P_BREITENGRAD, P_LAENGENGRAD)
VALUES('Hartsfield-Jackson International Airport Atlanta', 'ATL' ,33.636667, -84.428056),
('Beijing Capital International Airport' ,'PEK' ,40.0725, 116.5975),
('Dubai International Airport' ,'DXB' ,25.252778, 55.364444),
('Chicago O Hare International Airport' ,'ORD' ,41.978611, -87.904722),
('Tokyo International Airport' ,'HND' ,35.553333, 139.781111),
('Heathrow Airport' ,'LHR' ,51.4775, -0.461389),
('Los Angeles International Airport' ,'LAX' ,33.9425, -118.408056),
('Hong Kong International Airport' ,'HKG' ,22.308889, 113.914444),
('Paris Charles de Gaulle Airport' ,'CDG' ,49.009722, 2.547778),
('Dallas International Airport' ,'DFW' ,32.896944, -97.038056),
('Istanbul Atatürk Airport' ,'IST' ,40.976111, 28.814167),
('Frankfurt Airport' ,'FRA' ,50.033333, 8.570556);

INSERT INTO FLUGZEUG(TYP, ID, ANZAHL_SITZPLAETZE)
VALUES('Airbus A330-300', 'D-ABBB', 236),
('Airbus A330-300', 'D-ABBC', 240),
('Airbus A330-300', 'D-ABBD', 221),
('Airbus A330-300', 'D-ABBE', 231),
('Airbus A340-300', 'D-ABBF', 280),
('Airbus A340-300', 'D-ABBG', 271),
('Airbus A340-300', 'D-ABBH', 243),
('Airbus A340-600', 'D-ABBI', 266),
('Airbus A340-600', 'D-ABBK', 293),
('Airbus A380-800', 'D-ABBL', 509),
('Airbus A350-900', 'D-ABBM', 293),
('Airbus A350-900', 'D-ABBO', 297),
('Airbus A350-900', 'D-ABBP', 288),
('Airbus A350-900', 'D-ABBQ', 288),
('Airbus A320-200', 'D-ABBR', 168),
('Airbus A320-200', 'D-ABBS', 168),
('Airbus A320-200', 'D-ABBT', 170),
('Airbus A320-200', 'D-ABBU', 142),
('Boeing B747-8', 'D-ABBW', 364),
('Boeing B747-8', 'D-ABBX', 364),
('Boeing B747-8', 'D-ABBY', 364),
('Boeing B747-8', 'D-ABBZ', 364),
('Boeing B737-700','D-ABCA', 86),
('Boeing B737-700','D-ABCC', 88);



INSERT INTO  FLUGVERBINDUNG_(FLUGNUMMER,ID,IATA_CODES ,IATA_CODEZ)
VALUES('LH-100', 'D-ABBB', 'FRA', 'ATL'),
('LH-101', 'D-ABBF', 'FRA', 'PEK'),
('LH-102', 'D-ABBI', 'FRA', 'DXB'),
('LH-103', 'D-ABBI', 'FRA', 'ORD'),
('LH-104', 'D-ABBL', 'FRA', 'HND'),
('LH-105', 'D-ABBW', 'FRA', 'LHR'),
('LH-106', 'D-ABBX', 'FRA', 'LAX'),
('LH-107', 'D-ABBY', 'FRA', 'HKG'),
('LH-108', 'D-ABCC', 'FRA', 'CDG'),
('LH-109', 'D-ABCA', 'FRA', 'DFW'),
('LH-110', 'D-ABBQ', 'FRA', 'IST'),
('LH-200', 'D-ABBR', 'LHR', 'ATL'),
('LH-201', 'D-ABBS', 'LHR', 'PEK'),
('LH-202', 'D-ABBT', 'LHR', 'DXB'),
('LH-203', 'D-ABBU', 'LHR', 'ORD');


INSERT INTO  ABFLUG (FLUGNUMMER , AB_DATUM)
VALUES ('LH-100', '2017-05-01'),('LH-100', '2017-05-02'),
        ('LH-100', '2017-05-03'),('LH-100', '2017-05-04'),
        ('LH-100', '2017-05-05'),('LH-100', '2017-05-06'),
        ('LH-100', '2017-05-07'),('LH-100', '2017-05-08'),
        ('LH-101', '2017-05-01'),('LH-101', '2017-05-08'),
        ('LH-102', '2017-05-02'),('LH-102', '2017-05-04'),
        ('LH-102', '2017-05-06'),('LH-103', '2017-05-09'),
        ('LH-104', '2017-05-03'),('LH-104', '2017-05-05'),
        ('LH-104', '2017-05-07'),('LH-104', '2017-05-09'),
        ('LH-105', '2017-05-01'),('LH-105', '2017-05-02'),
        ('LH-105', '2017-05-03'),('LH-200', '2017-05-01'),
        ('LH-200', '2017-05-02'),('LH-201', '2017-05-03'),
        ('LH-202', '2017-05-05'),('LH-202', '2017-05-09'),
        ('LH-203', '2017-05-04'),('LH-203', '2017-05-05'),('LH-203', '2017-05-06');



INSERT INTO PASSAGIERE (NACHNAME , P_NAME , KUNDENNUMMER)
VALUES ('Roth', 'Michael', 1),('Schestag', 'Inge', 2),('Störl', 'Uta', 3),('Muth', 'Peter', 4);
/*Auf3a*/

/*Auf4*/



