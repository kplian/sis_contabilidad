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
require_once(dirname(__FILE__).'/../reportes/RAnexos7General.php');
require_once(dirname(__FILE__).'/../reportes/RAnexos8General.php');
require_once(dirname(__FILE__).'/../reportes/RAnexos9General.php');
require_once(dirname(__FILE__).'/../reportes/RAnexos11General.php');

class ACTAnexos extends ACTbase{

    function reporteAnexos(){
        //var_dump($this->objParam->getParametro('plantilla_reporte'));exit;
        if($this->objParam->getParametro('plantilla_reporte') == 'Anexos 7'){
            $this->objFunc = $this->create('MODAnexos');
            $this->res = $this->objFunc->listarAnexosAux($this->objParam);
            $titulo = 'Anexos';
            $nombreArchivo = uniqid(md5(session_id()) . $titulo);
            $nombreArchivo .= '.xls';
            $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
            $this->objParam->addParametro('datos', $this->res->datos);
            $this->objReporteFormato = new RAnexos7General($this->objParam);
            $this->objReporteFormato->generarDatos();
            $this->objReporteFormato->generarReporte();
        }elseif ($this->objParam->getParametro('plantilla_reporte')== 'Anexos 8'){
            $this->objFunc = $this->create('MODAnexos');
            $this->res = $this->objFunc->listarAnexos8($this->objParam);
            //  var_dump($this->res );exit;
            $titulo = 'Anexos 6';
            $nombreArchivo = uniqid(md5(session_id()) . $titulo);
            $nombreArchivo .= '.xls';
            $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
            $this->objParam->addParametro('datos', $this->res->datos);
            //Instancia la clase de excel
            $this->objReporteFormato = new RAnexos8General($this->objParam);
            $this->objReporteFormato->generarDatos();
            $this->objReporteFormato->generarReporte();
        }elseif ($this->objParam->getParametro('plantilla_reporte')== 'Anexos 9'){
            $this->objFunc = $this->create('MODAnexos');
            $this->res = $this->objFunc->listarAnexos9($this->objParam);
            //  var_dump($this->res );exit;
            $titulo = 'Anexos 6';
            $nombreArchivo = uniqid(md5(session_id()) . $titulo);
            $nombreArchivo .= '.xls';
            $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
            $this->objParam->addParametro('datos', $this->res->datos);
            //Instancia la clase de excel
            $this->objReporteFormato = new RAnexos9General($this->objParam);
            $this->objReporteFormato->generarDatos();
            $this->objReporteFormato->generarReporte();
        }elseif ($this->objParam->getParametro('plantilla_reporte')== 'Anexos 11' ){
            $this->objFunc = $this->create('MODAnexos');
            $this->res = $this->objFunc->listarAnexosAux($this->objParam);
            //  var_dump($this->res );exit;
            $titulo = 'Anexos 6';
            $nombreArchivo = uniqid(md5(session_id()) . $titulo);
            $nombreArchivo .= '.xls';
            $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
            $this->objParam->addParametro('datos', $this->res->datos);
            //Instancia la clase de excel
            $this->objReporteFormato = new RAnexos11General($this->objParam);
            $this->objReporteFormato->generarDatos();
            $this->objReporteFormato->generarReporte();
        }else {
            $this->objFunc = $this->create('MODAnexos');
            $this->res = $this->objFunc->PlantillaReporte($this->objParam);
            $titulo = 'Anexos';
            $nombreArchivo = uniqid(md5(session_id()) . $titulo);
            $nombreArchivo .= '.xls';
            $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
            $this->objParam->addParametro('datos', $this->res->datos);
            //Instancia la clase de excel
            $this->objReporteFormato = new RAnexosGeneral($this->objParam);
            $this->objReporteFormato->generarDatos();
            $this->objReporteFormato->generarReporte();
        }

        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado','Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }


}
?>