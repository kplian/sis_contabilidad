<?php
/**
 *@package pXP
 *@file gen-ACTPlantillaDetReporte.php
 *@author  (m.mamani)
 *@date 06-09-2018 20:33:59
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTPlantillaDetReporte extends ACTbase{

    function listarPlantillaDetReporte(){
        $this->objParam->defecto('ordenacion','id_plantilla_det_reporte');
        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_plantilla_reporte') != '') {
            $this->objParam->addFiltro("pdr.id_plantilla_reporte = " . $this->objParam->getParametro('id_plantilla_reporte'));
        }
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODPlantillaDetReporte','listarPlantillaDetReporte');
        } else{
            $this->objFunc=$this->create('MODPlantillaDetReporte');

            $this->res=$this->objFunc->listarPlantillaDetReporte($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarPlantillaDetReporte(){
        $this->objFunc=$this->create('MODPlantillaDetReporte');
        if($this->objParam->insertar('id_plantilla_det_reporte')){
            $this->res=$this->objFunc->insertarPlantillaDetReporte($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarPlantillaDetReporte($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarPlantillaDetReporte(){
        $this->objFunc=$this->create('MODPlantillaDetReporte');
        $this->res=$this->objFunc->eliminarPlantillaDetReporte($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function clonarPlantillaDetReporte(){
        $this->objFunc=$this->create('MODPlantillaDetReporte');
        $this->res=$this->objFunc->clonarPlantillaDetReporte($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>