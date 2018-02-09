---puertos_gf
alter table puertos_imp add column grado_ferrocarril int; 
update puertos_imp set grado_ferrocarril=g.cnt
from
(select f.id_puerto, c.cnt
from 
(select p.id as id_puerto, (
select n.id 
from via_ferrea_vertices_pgr As n
order by p.geom <-> n.geom LIMIT 1
)as closest_node 
from  
(select * from puertos_imp
where grado_ferrocarril is null ) as p ) as f
join via_ferrea_vertices_pgr as c
on c.id = f.closest_node) as g
where g.id_puerto = puertos_imp.id

---puertos_gc
alter table puertos_imp add column grado_carretera int; 
update puertos_imp set grado_carretera=g.cnt
from
(select f.id_puerto, c.cnt
from 
(select p.id as id_puerto, (
select n.id 
from red_2_vertices_pgr As n
order by p.geom <-> n.the_geom LIMIT 1
)as closest_node 
from  
(select * from puertos_imp
where grado_carretera is null ) as p ) as f
join red_2_vertices_pgr as c
on c.id = f.closest_node) as g
where g.id_puerto = puertos_imp.id

alter table puertos_imp add column grado_total int;
update puertos_imp set grado_total = grado_carretera + grado_ferrocarril

select * from puertos_imp

-- terminal_carrusel_gf
alter table terminal_carrusel add column grado_ferrocarril int; 
update terminal_carrusel set grado_ferrocarril=g.cnt
from
(select f.id_terminal, c.cnt
from 
(select p.id as id_terminal, (
select n.id 
from via_ferrea_vertices_pgr As n
order by p.geom <-> n.geom LIMIT 1
)as closest_node 
from  
(select * from terminal_carrusel
where grado_ferrocarril is null ) as p ) as f
join via_ferrea_vertices_pgr as c
on c.id = f.closest_node) as g
where g.id_terminal = terminal_carrusel.id

---terminal_gc
alter table terminal_carrusel add column grado_carretera int; 
update terminal_carrusel set grado_carretera=g.cnt
from
(select f.id_terminal, c.cnt
from 
(select p.id as id_terminal, (
select n.id 
from red_2_vertices_pgr As n
order by p.geom <-> n.the_geom LIMIT 1
)as closest_node 
from  
(select * from terminal_carrusel
where grado_carretera is null ) as p ) as f
join red_2_vertices_pgr as c
on c.id = f.closest_node) as g
where g.id_terminal = terminal_carrusel.id

alter table terminal_carrusel add column grado_total int;
update terminal_carrusel set grado_total = grado_carretera + grado_ferrocarril

select * from terminal_carrusel

--parques_industriales gf
alter table parques add column grado_ferrocarril int; 
update parques set grado_ferrocarril=g.cnt
from
(select f.id_parque, c.cnt
from 
(select p.id as id_parque, (
select n.id 
from via_ferrea_vertices_pgr As n
order by p.geom <-> n.geom LIMIT 1
)as closest_node 
from  
(select * from parques
where grado_ferrocarril is null ) as p ) as f
join via_ferrea_vertices_pgr as c
on c.id = f.closest_node) as g
where g.id_parque = parques.id

--parques_industriales gc

alter table parques add column grado_carretera int; 
update parques set grado_carretera=g.cnt
from
(select f.id_parque, c.cnt
from 
(select p.id as id_parque, (
select n.id 
from red_2_vertices_pgr As n
order by p.geom <-> n.the_geom LIMIT 1
)as closest_node 
from  
(select * from parques
where grado_carretera is null ) as p ) as f
join red_2_vertices_pgr as c
on c.id = f.closest_node) as g
where g.id_parque = parques.id

alter table parques add column grado_total int;
update parques set grado_total = grado_carretera + grado_ferrocarril
select * from parques

-- insertar en tabla nodos
delete 

INSERT INTO nodos (id, geom, tipo_nodo, grado_carretera, grado_ferrocarril, grado_total) 
SELECT id, geom, tipo_nodo, grado_carretera, grado_ferrocarril, grado_total
from
(select rp.id, rp.geom, rp.tipo_nodo, rp.grado_carretera, rp.grado_ferrocarril, rp.grado_total from 
(select * from terminal_carrusel) as rp
left join (select * from ciudades) as c
on st_intersects (rp.geom, c.geom) 
where c.id is null) as tc

DELETE FROM  nodos WHERE tipo_nodo = 'terminal_carrusel'
select distinct tipo_nodo from nodos

alter table nodos drop column grado_carretera;
alter table nodos drop column grado_ferrocarril;
alter table nodos drop column grado_total;

alter table nodos add column grado_carretera int;
alter table nodos add column grado_ferrocarril int;
alter table nodos add column grado_total int;
select * from nodos 

update nodos set grado_ferrocarril = g.id
from
(select c.grado_ferrocarril, c.id 
from ciudades c
join nodos
on nodos.id = c.id
where tipo_nodo= 'ciudad') as g