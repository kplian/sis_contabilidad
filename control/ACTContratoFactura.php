<?php
/**
 *@package pXP
 *@file gen-ACTContratoFactura.php
 *@author  (m.mamani)
 *@date 19-09-2018 13:16:55
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTContratoFactura extends ACTbase{

    function listarContratoFactura(){
        $this->objParam->defecto('ordenacion','id_contrato');
        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_gestion') != '' ) {
            $this->objParam->addFiltro("co.id_gestion = " . $this->objParam->getParametro('id_gestion'));
        }
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODContratoFactura','listarContratoFactura');
        } else{
            $this->objFunc=$this->create('MODContratoFactura');

            $this->res=$this->objFunc->listarContratoFactura($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarContratoFactura(){
        $this->objFunc=$this->create('MODContratoFactura');
        if($this->objParam->insertar('id_contrato')){
            $this->res=$this->objFunc->insertarContratoFactura($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarContratoFactura($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarContratoFactura(){
        $this->objFunc=$this->create('MODContratoFactura');
        $this->res=$this->objFunc->eliminarContratoFactura($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>