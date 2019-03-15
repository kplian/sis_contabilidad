<?php
/**
 *@package pXP
 *@file gen-ACTAnexos.php
 *@author  Manuel Guerra
 *@date 30-07-2018 12:12:51
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 ** ISSUE            FECHA:		      AUTOR       DESCRIPCION
 *
 */

require_once(dirname(__FILE__).'/../reportes/RAnexosGeneral.php');

class ACTAnexos extends ACTbase{

    function reporteAnexos(){

        $this->objFunc = $this->create('MODAnexos');
        $this->res = $this->objFunc->PlantillaReporte($this->objParam);
        $titulo = 'Anexos 2';
        $nombreArchivo = uniqid(md5(session_id()) . $titulo);
        $nombreArchivo .= '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('datos', $this->res->datos);
        //Instancia la clase de excel
        $this->objReporteFormato = new RAnexosGeneral($this->objParam);
        $this->objReporteFormato->generarDatos();
        $this->objReporteFormato->generarReporte();

        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado','Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }


}
?>