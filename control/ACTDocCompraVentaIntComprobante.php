<?php
/**
 *@package pXP
 *@file ACTDocCompraVentaIntComprobante.php
 *@author  Gonzalo Sarmiento
 *@date 01-03-2017
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */
require_once(dirname(__FILE__).'/../../pxp/pxpReport/DataSource.php');
require_once(dirname(__FILE__).'/../reportes/RDocumentoComprobanteXls.php');

class ACTDocCompraVentaIntComprobante extends ACTbase{

    function recuperarDocCompraIntComprobante(){
        $this->objFunc = $this->create('MODDocCompraVentaIntComprobante');
        $cbteHeader = $this->objFunc->listarDocCompraVentaIntComprobante($this->objParam);
        if($cbteHeader->getTipo() == 'EXITO'){
            return $cbteHeader;
        }
        else{
            $cbteHeader->imprimirRespuesta($cbteHeader->generarJson());
            exit;
        }

    }

    function reporteDocCompraIntComprobante(){

        $nombreArchivo = 'DocumentoComprobante'.uniqid(md5(session_id())).'.xls';

        $dataSource = $this->recuperarDocCompraIntComprobante();

        //parametros basicos
        $tamano = 'LETTER';
        $orientacion = 'L';
        $titulo = 'Consolidado';

        $this->objParam->addParametro('orientacion',$orientacion);
        $this->objParam->addParametro('tamano',$tamano);
        $this->objParam->addParametro('titulo_archivo',$titulo);
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);

        $reporte = new RDocumentoComprobanteXls($this->objParam);
        $reporte->datosHeader($dataSource->getDatos());
        $reporte->generarReporte();

        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado','Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }


}

?>