<?php
/**
 *@package pXP
 *@file gen-MODAnexo.php
 *@author  (Manuel Guerra)
 *@date 30-07-2018 12:12:51
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODAnexos extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function PlantillaReporte(){
        $this->procedimiento='conta.f_plantilla_reporte_generar';
        $this-> setCount(false);
        $this->setTipoRetorno('record');
        $this->transaccion='CONTA_ANRES_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //paramtros
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('id_plantilla_reporte','id_plantilla_reporte','int');

        $this->captura('id','int4');
        $this->captura('codigo','varchar');
        $this->captura('orden','numeric');
        $this->captura('columna','varchar');
        $this->captura('titulo_columna','varchar');
        $this->captura('sudtitulo','varchar');
        $this->captura('gestion','int4');
        $this->captura('periodo','int4');
        $this->captura('importe','numeric');
        $this->captura('titulo','varchar');
        $this->captura('glosa','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        /*echo $this->getConsulta();
        exit;*/
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
}
?>















