<?php
/**
 *@package pXP
 *@file gen-MODDetalleDetReporteAux.php
 *@author  (m.mamani)
 *@date 19-10-2018 15:39:09
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODDetalleDetReporteAux extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarDetalleDetReporteAux(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_detalle_det_reporte_aux_sel';
        $this->transaccion='CONTA_DRA_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_detalle_det_reporte_aux','int4');
        $this->captura('estado_reg','varchar');
        $this->captura('partida','text');
        $this->captura('orden_fila','int4');
        $this->captura('origen','varchar');
        $this->captura('concepto','text');
        $this->captura('id_usuario_reg','int4');
        $this->captura('usuario_ai','varchar');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_ai','int4');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('id_plantilla_reporte','int4');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarDetalleDetReporteAux(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_detalle_det_reporte_aux_ime';
        $this->transaccion='CONTA_DRA_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('partida','partida','text');
        $this->setParametro('orden_fila','orden_fila','int4');
        $this->setParametro('origen','origen','varchar');
        $this->setParametro('concepto','concepto','text');
        $this->setParametro('id_plantilla_reporte','id_plantilla_reporte','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarDetalleDetReporteAux(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_detalle_det_reporte_aux_ime';
        $this->transaccion='CONTA_DRA_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_detalle_det_reporte_aux','id_detalle_det_reporte_aux','int4');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('partida','partida','text');
        $this->setParametro('orden_fila','orden_fila','int4');
        $this->setParametro('origen','origen','varchar');
        $this->setParametro('concepto','concepto','text');
        $this->setParametro('id_plantilla_reporte','id_plantilla_reporte','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarDetalleDetReporteAux(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_detalle_det_reporte_aux_ime';
        $this->transaccion='CONTA_DRA_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_detalle_det_reporte_aux','id_detalle_det_reporte_aux','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>