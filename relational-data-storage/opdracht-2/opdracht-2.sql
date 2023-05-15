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

