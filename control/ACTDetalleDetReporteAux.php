<?php
/**
 *@package pXP
 *@file gen-ACTDetalleDetReporteAux.php
 *@author  (m.mamani)
 *@date 19-10-2018 15:39:09
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTDetalleDetReporteAux extends ACTbase{

    function listarDetalleDetReporteAux(){
        $this->objParam->defecto('ordenacion','id_detalle_det_reporte_aux');
        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_plantilla_reporte') != '') {
            $this->objParam->addFiltro("dra.id_plantilla_reporte = " . $this->objParam->getParametro('id_plantilla_reporte'));
        }
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODDetalleDetReporteAux','listarDetalleDetReporteAux');
        } else{
            $this->objFunc=$this->create('MODDetalleDetReporteAux');

            $this->res=$this->objFunc->listarDetalleDetReporteAux($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarDetalleDetReporteAux(){
        $this->objFunc=$this->create('MODDetalleDetReporteAux');
        if($this->objParam->insertar('id_detalle_det_reporte_aux')){
            $this->res=$this->objFunc->insertarDetalleDetReporteAux($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarDetalleDetReporteAux($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarDetalleDetReporteAux(){
        $this->objFunc=$this->create('MODDetalleDetReporteAux');
        $this->res=$this->objFunc->eliminarDetalleDetReporteAux($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>