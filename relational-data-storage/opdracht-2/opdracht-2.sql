--1
SET GLOBAL FOREIGN_KEY_CHECKS=0;

--2
alter table mhl_cities 
add constraint communeFK 
foreign key(commune_ID) references mhl_communes(id)


alter table mhl_contacts 
add constraint supplierFK 
foreign key(supplier_ID) references mhl_suppliers(id)


alter table mhl_detaildefs 
add constraint propertytypesFK 
foreign key(propertytype_ID) references mhl_propertytypes(id)


alter table mhl_hitcount
add constraint supplierhitcountFK 
foreign key(supplier_ID) references mhl_suppliers(id)


alter table mhl_properties
add constraint supplierpropFK 
foreign key(supplier_ID) references mhl_suppliers(id)


alter table mhl_properties 
add constraint propertytypepropertyFK 
foreign key(propertytype_ID) references mhl_propertytypes(id)


alter table mhl_rubrieken
add constraint parentFK 
foreign key(parent) references mhl_rubrieken(id)


alter table mhl_suppliers 
add constraint membertypeFK 
foreign key(membertype) references mhl_membertypes(id)


alter table mhl_suppliers 
add constraint companyFK 
foreign key(company) references mhl_companies(id)


alter table mhl_suppliers_mhl_rubriek_view 
add constraint suppliersviewFK 
foreign key(mhl_suppliers_ID) references mhl_suppliers(id)


alter table mhl_suppliers_mhl_rubriek_view 
add constraint rubriekviewFK 
foreign key(mhl_rubriek_view_ID) references mhl_rubrieken(id)


alter table mhl_yn_properties
add constraint supplierynFK 
foreign key(supplier_ID) references mhl_suppliers(id)


alter table mhl_yn_properties
add constraint propertytypeynFK 
foreign key(propertytype_ID) references mhl_propertytypes(id)


alter table mhl_suppliers
add constraint postcodeFK 
foreign key(postcode) references pc_lat_long(pc6)


alter table mhl_suppliers
add constraint postbusFK 
foreign key(p_postcode) references pc_lat_long(pc6)

--3
SET GLOBAL FOREIGN_KEY_CHECKS=1;

--4
--SUPPLIER
CREATE TABLE x_suppliers (
    id int(11),
    supplier_ID int(11),
    membertype int(11),
    company int(11),
    name varchar(75),
    straat varchar(50),
    huisnr varchar(25),
    postcode varchar(7),
    city_ID int(11),
    p_address varchar(30),
    p_postcode varchar(7),
    p_city_ID int(11),
    joindate date,
    PRIMARY KEY (id)
);

--alle rijen waar de FK's kloppen
SELECT  S.id, S.membertype, S.company, S.name, S.straat, S.huisnr, S.postcode, S.city_ID, S.p_address, S.p_postcode, S.p_city_ID, S.joindate
FROM    mhl_suppliers AS S
JOIN    mhl_membertypes AS M ON S.membertype = M.id
JOIN    mhl_companies AS C ON S.company = C.id
JOIN    pc_lat_long AS P ON S.postcode = P.pc6 


--alle rijen waar de FK's niet kloppen
SELECT  id, membertype, company, name, straat, huisnr, postcode, city_ID, p_address, p_postcode, p_city_ID, joindate
FROM    mhl_suppliers
WHERE   membertype=0 OR company=0

SELECT  id, membertype, company, name, straat, huisnr, postcode, city_ID, p_address, p_postcode, p_city_ID, joindate
FROM    mhl_suppliers
WHERE   NOT EXISTS (SELECT id FROM mhl_membertypes WHERE id=mhl_suppliers.membertype) 
        OR NOT EXISTS (SELECT id FROM mhl_companies WHERE id=mhl_suppliers.company)
        OR NOT EXISTS (SELECT pc6 FROM pc_lat_long WHERE pc6=mhl_suppliers.postcode)


--rijen die niet kloppen verplaatsen
INSERT  INTO x_suppliers (supplier_ID, membertype, company, name, straat, huisnr, postcode, city_ID, p_address, p_postcode, p_city_ID, joindate)
SELECT  id, membertype, company, name, straat, huisnr, postcode, city_ID, p_address, p_postcode, p_city_ID, joindate
FROM    mhl_suppliers
WHERE   NOT EXISTS (SELECT id FROM mhl_membertypes WHERE id=mhl_suppliers.membertype) 
        OR NOT EXISTS (SELECT id FROM mhl_companies WHERE id=mhl_suppliers.company)
        OR NOT EXISTS (SELECT pc6 FROM pc_lat_long WHERE pc6=mhl_suppliers.postcode);

DELETE  FROM mhl_suppliers
WHERE   NOT EXISTS (SELECT id FROM mhl_membertypes WHERE id=mhl_suppliers.membertype) 
        OR NOT EXISTS (SELECT id FROM mhl_companies WHERE id=mhl_suppliers.company)
        OR NOT EXISTS (SELECT pc6 FROM pc_lat_long WHERE pc6=mhl_suppliers.postcode);


--CITIES
CREATE TABLE x_cities (
    id int(11),
    cities_ID int(11),
    commune_ID int(11),
    name varchar(100)
);

INSERT  INTO x_cities (cities_ID, commune_ID, name)
SELECT  id, commune_ID, name
FROM    mhl_cities
WHERE   NOT EXISTS (SELECT id FROM mhl_communes WHERE id=mhl_cities.commune_ID);

DELETE  FROM mhl_cities
WHERE   NOT EXISTS (SELECT id FROM mhl_communes WHERE id=mhl_cities.commune_ID);


--CONTACTS
CREATE TABLE x_contacts (
    id int(11),
    contacts_id int(11),
    supplier_ID int(11),
    department int(11),
    contacttype varchar(75),
    name varchar(75),
    email varchar(75),
    tel varchar(15)
);

INSERT  INTO x_contacts (contacts_id, supplier_ID, department, contacttype, name, email, tel)
SELECT  id, supplier_ID, department, contacttype, name, email, tel
FROM    mhl_contacts
WHERE   NOT EXISTS (SELECT id FROM mhl_suppliers WHERE id=mhl_contacts.supplier_ID)

DELETE  FROM mhl_contacts
WHERE   NOT EXISTS (SELECT id FROM mhl_suppliers WHERE id=mhl_contacts.supplier_ID)


--DETAILDEFS
CREATE TABLE x_detaildefs (
    id int(11),
    detaildefs_id int(11),
    vlevel int(11),
    group_ID int(11),
    display_order int(11),
    properties varchar(100),
    propertytype_ID int(11),
    property_DEF char(25),
    display_name varchar(50)
);

INSERT  INTO x_detaildefs (detaildefs_id, vlevel, group_ID, display_order, properties, propertytype_ID, property_DEF, display_name)
SELECT  id, vlevel, group_ID, display_order, properties, propertytype_ID, property_DEF, display_name
FROM    mhl_detaildefs
WHERE   NOT EXISTS (SELECT id FROM mhl_detailgroups WHERE id=mhl_detaildefs.group_ID)
        OR NOT EXISTS (SELECT id FROM mhl_propertytypes WHERE id=mhl_detaildefs.propertytype_ID)

DELETE  FROM mhl_detaildefs
WHERE   NOT EXISTS (SELECT id FROM mhl_detailgroups WHERE id=mhl_detaildefs.group_ID)
        OR NOT EXISTS (SELECT id FROM mhl_propertytypes WHERE id=mhl_detaildefs.propertytype_ID)


--HITCOUNT
CREATE TABLE x_hitcount (
    supplier_ID smallint(11),
    year tinyint(11),
    month int(11),
    hitcount int(11)
);

INSERT  INTO x_hitcount (supplier_ID, year, month, hitcount)
SELECT  supplier_ID, year, month, hitcount
FROM    mhl_hitcount
WHERE   NOT EXISTS (SELECT id FROM mhl_suppliers WHERE id=mhl_hitcount.supplier_ID)

DELETE FROM mhl_hitcount
WHERE   NOT EXISTS (SELECT id FROM mhl_suppliers WHERE id=mhl_hitcount.supplier_ID)


--PROPERTIES
CREATE TABLE x_properties (
    id int(11),
    supplier_ID int(11),
    propertytype_ID int(11),
    content text
);

INSERT INTO x_properties (id, supplier_ID, propertytype_ID, content)
SELECT  id, supplier_ID, propertytype_ID, content
FROM    mhl_properties
WHERE   NOT EXISTS (SELECT id FROM mhl_suppliers WHERE id=mhl_properties.supplier_ID)
        OR NOT EXISTS (SELECT id FROM mhl_propertytypes WHERE id=mhl_properties.propertytype_ID)

DELETE  FROM mhl_properties
WHERE   NOT EXISTS (SELECT id FROM mhl_suppliers WHERE id=mhl_properties.supplier_ID)
        OR NOT EXISTS (SELECT id FROM mhl_propertytypes WHERE id=mhl_properties.propertytype_ID)



--SUPPLIERS_RUBRIEK_VIEW
CREATE TABLE x_supplier_rubriek_view (
    id int(11),
    mhl_suppliers_ID int(11),
    mhl_rubriek_view_ID int(11)
)

INSERT  INTO x_supplier_rubriek_view (id, mhl_suppliers_ID, mhl_rubriek_view_ID)
SELECT  id, mhl_suppliers_ID, mhl_rubriek_view_ID
FROM    mhl_suppliers_mhl_rubriek_view
WHERE   NOT EXISTS (SELECT id FROM mhl_suppliers WHERE id=mhl_suppliers_mhl_rubriek_view.mhl_suppliers_ID)
        OR NOT EXISTS (SELECT id FROM mhl_rubrieken WHERE id=mhl_suppliers_mhl_rubriek_view.mhl_rubriek_view_ID)

DELETE  FROM mhl_suppliers_mhl_rubriek_view
WHERE   NOT EXISTS (SELECT id FROM mhl_suppliers WHERE id=mhl_suppliers_mhl_rubriek_view.mhl_suppliers_ID)
        OR NOT EXISTS (SELECT id FROM mhl_rubrieken WHERE id=mhl_suppliers_mhl_rubriek_view.mhl_rubriek_view_ID)



--YN_PROPERTIES
CREATE TABLE x_yn_properties (
    id int(11),
    supplier_ID int(11),
    propertytype_ID int(11),
    content set('Y','N')
)

INSERT  INTO x_yn_properties (id, supplier_ID, propertytype_ID, content)
SELECT  id, supplier_ID, propertytype_ID, content
FROM    mhl_yn_properties
WHERE   NOT EXISTS (SELECT id FROM mhl_suppliers WHERE id=mhl_yn_properties.supplier_ID)
        OR NOT EXISTS (SELECT id FROM mhl_propertytypes WHERE id=mhl_yn_properties.propertytype_ID)

DELETE  FROM mhl_yn_properties
WHERE   NOT EXISTS (SELECT id FROM mhl_suppliers WHERE id=mhl_yn_properties.supplier_ID)
        OR NOT EXISTS (SELECT id FROM mhl_propertytypes WHERE id=mhl_yn_properties.propertytype_ID)

