* EH2021 Data Cleaning Script
* Author: Paolo Machaca

clear all
cls

********************************************************************************
**# 1. Definir Global
********************************************************************************

if ("`c(username)'" == "usuario") {
    global base "C:/Users/usuario/Documents/EH_Bolivia_2021"
    global raw  "$base/raw"
    global clean "$base/clean"
    global temp "$base/temp"
}

********************************************************************************
**# 2. Cargar base de datos y seleccionar variables de interés
********************************************************************************

use "$raw/EH2021_Persona.dta", clear

* Variables seleccionadas:
* - identificadores: folio, upm, estrato, factor
* - características: edad, sexo, area, departamento
* - educación: nivel educativo
* - ingresos: ingreso hogar per cápita

keep folio upm estrato factor s01a_03 s01a_04c s01a_05 area depto niv_ed_g yhogpc

********************************************************************************
**# 3. Renombrar variables para mayor claridad
********************************************************************************

rename s01a_03 edad
rename s01a_04c birth_year
rename s01a_05 sexo
rename niv_ed_g nivel_edu

********************************************************************************
**# 4. Crear variables nuevas
********************************************************************************

* Crear dummy para mujer
gen mujer = (sexo == 2)

* Crear grupo de edad
recode edad (0/14 = 1 "Niñez") (15/24 = 2 "Juventud") (25/59 = 3 "Adultez") (60/100 = 4 "Adultez Mayor"), gen(grupo_edad)

* Clasificar pobreza (ejemplo usando línea de pobreza referencial Bs 800)
gen pobre = (yhogpc < 800)

********************************************************************************
**# 5. Guardar base limpia
********************************************************************************

save "$clean/EH2021_persona_clean.dta", replace

********************************************************************************
**# 6. Exploración rápida (opcional)
********************************************************************************

tab area
summ edad yhogpc

* Fin del script
