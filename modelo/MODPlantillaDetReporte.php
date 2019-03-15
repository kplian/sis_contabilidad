<?php
/**
 *@package pXP
 *@file gen-MODPlantillaDetReporte.php
 *@author  (m.mamani)
 *@date 06-09-2018 20:33:59
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODPlantillaDetReporte extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarPlantillaDetReporte(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_plantilla_det_reporte_sel';
        $this->transaccion='CONTA_PDR_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_plantilla_det_reporte','int4');
        $this->captura('origen','varchar');
        $this->captura('estado_reg','varchar');
        $this->captura('concepto','text');
        $this->captura('codigo_columna','varchar');
        $this->captura('columna','varchar');
        $this->captura('order_fila','int4');
        $this->captura('id_plantilla_reporte','int4');
        $this->captura('formula','varchar');
        $this->captura('partida','varchar');
        $this->captura('usuario_ai','varchar');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_reg','int4');
        $this->captura('id_usuario_ai','int4');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('desc_cuenta','varchar');
        $this->captura('desc_partida','varchar');
        $this->captura('nombre_columna','text');
        $this->captura('saldo_inical','varchar');
        $this->captura('formulario','varchar');
        $this->captura('codigo_formulario','text');
        $this->captura('saldo_anterior','varchar');
        $this->captura('operacion','varchar');
        $this->captura('apertura_cb','varchar');
        $this->captura('cierre_cb','varchar');
        $this->captura('tipo_periodo','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarPlantillaDetReporte(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_plantilla_det_reporte_ime';
        $this->transaccion='CONTA_PDR_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('origen','origen','varchar');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('concepto','concepto','text');
        $this->setParametro('codigo_columna','codigo_columna','varchar');
        $this->setParametro('columna','columna','varchar');
        $this->setParametro('order_fila','order_fila','int4');
        $this->setParametro('id_plantilla_reporte','id_plantilla_reporte','int4');
        $this->setParametro('formula','formula','varchar');
        $this->setParametro('partida','partida','varchar');
        $this->setParametro('nombre_columna','nombre_columna','text');
        $this->setParametro('saldo_inical','saldo_inical','varchar');
        $this->setParametro('formulario','formulario','varchar');
        $this->setParametro('codigo_formulario','codigo_formulario','text');
        $this->setParametro('saldo_anterior','saldo_anterior','varchar');
        $this->setParametro('operacion','operacion','varchar');
        $this->setParametro('apertura_cb','apertura_cb','varchar');
        $this->setParametro('cierre_cb','cierre_cb','varchar');
        $this->setParametro('tipo_periodo','tipo_periodo','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarPlantillaDetReporte(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_plantilla_det_reporte_ime';
        $this->transaccion='CONTA_PDR_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_plantilla_det_reporte','id_plantilla_det_reporte','int4');
        $this->setParametro('origen','origen','varchar');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('concepto','concepto','text');
        $this->setParametro('codigo_columna','codigo_columna','varchar');
        $this->setParametro('columna','columna','varchar');
        $this->setParametro('order_fila','order_fila','int4');
        $this->setParametro('id_plantilla_reporte','id_plantilla_reporte','int4');
        $this->setParametro('formula','formula','varchar');
        $this->setParametro('partida','partida','varchar');
        $this->setParametro('nombre_columna','nombre_columna','text');
        $this->setParametro('saldo_inical','saldo_inical','varchar');
        $this->setParametro('formulario','formulario','varchar');
        $this->setParametro('codigo_formulario','codigo_formulario','text');
        $this->setParametro('saldo_anterior','saldo_anterior','varchar');
        $this->setParametro('operacion','operacion','varchar');
        $this->setParametro('apertura_cb','apertura_cb','varchar');
        $this->setParametro('cierre_cb','cierre_cb','varchar');
        $this->setParametro('tipo_periodo','tipo_periodo','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarPlantillaDetReporte(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_plantilla_det_reporte_ime';
        $this->transaccion='CONTA_PDR_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_plantilla_det_reporte','id_plantilla_det_reporte','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function clonarPlantillaDetReporte(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_plantilla_det_reporte_ime';
        $this->transaccion='CONTA_PDR_CLO';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_plantilla_det_reporte','id_plantilla_det_reporte','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>