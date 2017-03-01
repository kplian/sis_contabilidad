<?php
/**
 *@package pXP
 *@file MODDocCompraVentaIntComprobante.php
 *@author  Gonzalo Sarmiento
 *@date 29-02-2016 19:40:34
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */
class MODDocCompraVentaIntComprobante extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarDocCompraVentaIntComprobante(){

        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.f_doc_compra_venta_int_comprobante';
        $this->transaccion='CONTA_DOCINTCOMP_REP';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);
        $this->setTipoRetorno('record');

        //captura parametros adicionales para el count

        $this->setParametro('fecha_ini','fecha_ini','date');
        $this->setParametro('fecha_fin','fecha_fin','date');

        //Definicion de la lista del resultado del query
        $this->captura('fecha','DATE');
        $this->captura('nit','VARCHAR');
        $this->captura('razon_social','VARCHAR');
        $this->captura('desc_plantilla','VARCHAR');
        $this->captura('nro_documento','VARCHAR');
        $this->captura('nro_dui','VARCHAR');
        $this->captura('nro_autorizacion','VARCHAR');
        $this->captura('codigo_control','VARCHAR');
        $this->captura('importe_doc','NUMERIC');
        $this->captura('importe_ice','NUMERIC');
        $this->captura('importe_descuento','NUMERIC');
        $this->captura('importe_excento','NUMERIC');
        $this->captura('liquido','NUMERIC');
        $this->captura('importe_sujeto','NUMERIC');
        $this->captura('importe_iva','NUMERIC');
        $this->captura('importe_gasto','NUMERIC');
        $this->captura('porc_gasto_prorrateado','NUMERIC');
        $this->captura('sujeto_prorrateado','NUMERIC');
        $this->captura('iva_prorrateado','NUMERIC');
        $this->captura('codigo','VARCHAR');
        $this->captura('nro_cuenta','VARCHAR');
        $this->captura('origen','VARCHAR');
        $this->captura('id_int_comprobante','INTEGER');
        $this->captura('id_doc_compra_venta','INTEGER');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>