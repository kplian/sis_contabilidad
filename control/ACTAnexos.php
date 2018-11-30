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
require_once(dirname(__FILE__).'/../../pxp/pxpReport/ReportWriter.php');
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
include_once(dirname(__FILE__).'/../../sis_seguridad/modelo/MODSubsistema.php');

include_once(dirname(__FILE__).'/../../lib/PHPMailer/class.phpmailer.php');
include_once(dirname(__FILE__).'/../../lib/PHPMailer/class.smtp.php');
include_once(dirname(__FILE__).'/../../lib/lib_general/cls_correo_externo.php');
require_once(dirname(__FILE__).'/../reportes/RAnexosXls.php');
require_once(dirname(__FILE__).'/../reportes/RAnexos2Xls.php');
require_once(dirname(__FILE__).'/../reportes/RAnexos4Xls.php');
require_once(dirname(__FILE__).'/../reportes/RAnexos5Xls.php');
require_once(dirname(__FILE__).'/../reportes/RAnexos6Xls.php');
require_once(dirname(__FILE__).'/../reportes/RAnexos7Xls.php');
require_once(dirname(__FILE__).'/../reportes/RAnexos8Xls.php');
require_once(dirname(__FILE__).'/../reportes/RAnexos9Xls.php');
require_once(dirname(__FILE__).'/../reportes/RAnexos11Xls.php');
require_once(dirname(__FILE__).'/../reportes/RAnexos10Xls.php');

class ACTAnexos extends ACTbase{

    function reporteAnexos(){

        if($this->objParam->getParametro('tipo_anexo')== 'ane_1'){

            $this->objFunc = $this->create('MODAnexos');
            $this->res = $this->objFunc->ListarAnexos1($this->objParam);
            $titulo = 'Anexos 2';
            $nombreArchivo = uniqid(md5(session_id()) . $titulo);
            $nombreArchivo .= '.xls';
            $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
            $this->objParam->addParametro('datos', $this->res->datos);
            //Instancia la clase de excel
            $this->objReporteFormato = new RAnexosXls($this->objParam);
            $this->objReporteFormato->generarDatos();
            $this->objReporteFormato->generarReporte();

        }elseif ($this->objParam->getParametro('tipo_anexo')== 'ane_2') {

            $this->objFunc = $this->create('MODAnexos');
            $this->res = $this->objFunc->listarAnexos2($this->objParam);
            $titulo = 'Anexos 2';
            $nombreArchivo = uniqid(md5(session_id()) . $titulo);
            $nombreArchivo .= '.xls';
            $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
            $this->objParam->addParametro('datos', $this->res->datos);
            //Instancia la clase de excel
            $this->objReporteFormato = new RAnexos2Xls($this->objParam);
            $this->objReporteFormato->generarDatos();
            $this->objReporteFormato->generarReporte();
        }elseif ($this->objParam->getParametro('tipo_anexo')== 'ane_4'){

            $this->objFunc = $this->create('MODAnexos');
            $this->res = $this->objFunc->listarAnexos4($this->objParam);
            $titulo = 'Anexos 4';
            $nombreArchivo = uniqid(md5(session_id()) . $titulo);
            $nombreArchivo .= '.xls';
            $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
            $this->objParam->addParametro('datos', $this->res->datos);
            //Instancia la clase de excel
            $this->objReporteFormato = new RAnexos4Xls($this->objParam);
            $this->objReporteFormato->generarDatos();
            $this->objReporteFormato->generarReporte();
        }elseif ($this->objParam->getParametro('tipo_anexo')== 'ane_5'){

            $this->objFunc = $this->create('MODAnexos');
            $this->res = $this->objFunc->listarAnexos5($this->objParam);
            $titulo = 'Anexos 4';
            $nombreArchivo = uniqid(md5(session_id()) . $titulo);
            $nombreArchivo .= '.xls';
            $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
            $this->objParam->addParametro('datos', $this->res->datos);
            //Instancia la clase de excel
            $this->objReporteFormato = new RAnexos5Xls($this->objParam);
            $this->objReporteFormato->generarDatos();
            $this->objReporteFormato->generarReporte();

        }elseif ($this->objParam->getParametro('tipo_anexo')== 'ane_6'){

            $this->objFunc = $this->create('MODAnexos');
            $dataSource = $this->res = $this->objFunc->listarAnexos6($this->objParam);
            $this->objFunc = $this->create('MODAnexos');
            $dataSourceAux =  $this->res2 = $this->objFunc->listaDetalleAux($this->objParam);

            $titulo = 'Anexos 6';
            $nombreArchivo = uniqid(md5(session_id()) . $titulo);
            $nombreArchivo .= '.xls';
            $this->objParam->addParametro('nombre_archivo', $nombreArchivo);

            $reporte = new RAnexos6Xls($this->objParam);
            $reporte->datosHeader($dataSource->getDatos(),$dataSourceAux->getDatos());
            $reporte->generarDatos();
            $reporte->generarReporte();


        }elseif ($this->objParam->getParametro('tipo_anexo')== 'ane_7' || $this->objParam->getParametro('tipo_anexo')== 'ane_7_1'  ){
            $this->objFunc = $this->create('MODAnexos');
            $this->res = $this->objFunc->listarAnexos7($this->objParam);
            //  var_dump($this->res );exit;
            $titulo = 'Anexos 7';
            $nombreArchivo = uniqid(md5(session_id()) . $titulo);
            $nombreArchivo .= '.xls';
            $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
            $this->objParam->addParametro('datos', $this->res->datos);
            //Instancia la clase de excel
            $this->objReporteFormato = new RAnexos7Xls($this->objParam);
            $this->objReporteFormato->generarDatos();
            $this->objReporteFormato->generarReporte();
        }elseif ($this->objParam->getParametro('tipo_anexo')== 'ane_8'){
            $this->objFunc = $this->create('MODAnexos');
            $this->res = $this->objFunc->listarAnexos8($this->objParam);
            //  var_dump($this->res );exit;
            $titulo = 'Anexos 6';
            $nombreArchivo = uniqid(md5(session_id()) . $titulo);
            $nombreArchivo .= '.xls';
            $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
            $this->objParam->addParametro('datos', $this->res->datos);
            //Instancia la clase de excel
            $this->objReporteFormato = new RAnexos8Xls($this->objParam);
            $this->objReporteFormato->generarDatos();
            $this->objReporteFormato->generarReporte();
        }elseif ($this->objParam->getParametro('tipo_anexo')== 'ane_9'){
            $this->objFunc = $this->create('MODAnexos');
            $this->res = $this->objFunc->listarAnexos9($this->objParam);
            //  var_dump($this->res );exit;
            $titulo = 'Anexos 6';
            $nombreArchivo = uniqid(md5(session_id()) . $titulo);
            $nombreArchivo .= '.xls';
            $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
            $this->objParam->addParametro('datos', $this->res->datos);
            //Instancia la clase de excel
            $this->objReporteFormato = new RAnexos9Xls($this->objParam);
            $this->objReporteFormato->generarDatos();
            $this->objReporteFormato->generarReporte();
        }elseif ($this->objParam->getParametro('tipo_anexo')== 'ane_11' ){
            $this->objFunc = $this->create('MODAnexos');
            $this->res = $this->objFunc->listarAnexos7($this->objParam);
            //  var_dump($this->res );exit;
            $titulo = 'Anexos 6';
            $nombreArchivo = uniqid(md5(session_id()) . $titulo);
            $nombreArchivo .= '.xls';
            $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
            $this->objParam->addParametro('datos', $this->res->datos);
            //Instancia la clase de excel
            $this->objReporteFormato = new RAnexos11Xls($this->objParam);
            $this->objReporteFormato->generarDatos();
            $this->objReporteFormato->generarReporte();
        }elseif ($this->objParam->getParametro('tipo_anexo')== 'ane_10' ){
            $this->objFunc = $this->create('MODAnexos');
            $this->res = $this->objFunc->listarAnexos10($this->objParam);
            //  var_dump($this->res );exit;
            $titulo = 'Anexos 6';
            $nombreArchivo = uniqid(md5(session_id()) . $titulo);
            $nombreArchivo .= '.xls';
            $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
            $this->objParam->addParametro('datos', $this->res->datos);
            //Instancia la clase de excel
            $this->objReporteFormato = new RAnexos10Xls($this->objParam);
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