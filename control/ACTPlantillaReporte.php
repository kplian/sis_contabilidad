<?php
/**
 *@package pXP
 *@file gen-ACTPlantillaReporte.php
 *@author  (m.mamani)
 *@date 06-09-2018 19:52:00
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTPlantillaReporte extends ACTbase{

    function listarPlantillaReporte(){
        $this->objParam->defecto('ordenacion','id_plantilla_reporte');

        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODPlantillaReporte','listarPlantillaReporte');
        } else{
            $this->objFunc=$this->create('MODPlantillaReporte');

            $this->res=$this->objFunc->listarPlantillaReporte($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarPlantillaReporte(){
        $this->objFunc=$this->create('MODPlantillaReporte');
        if($this->objParam->insertar('id_plantilla_reporte')){
            $this->res=$this->objFunc->insertarPlantillaReporte($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarPlantillaReporte($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarPlantillaReporte(){
        $this->objFunc=$this->create('MODPlantillaReporte');
        $this->res=$this->objFunc->eliminarPlantillaReporte($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>