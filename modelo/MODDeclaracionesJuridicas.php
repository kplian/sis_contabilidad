<?php
/**
 *@package pXP
 *@file gen-MODDeclaracionesJuridicas.php
 *@author  (m.mamani)
 *@date 27-08-2018 14:51:02
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODDeclaracionesJuridicas extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarDeclaracionesJuridicas(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_declaraciones_juridicas_sel';
        $this->transaccion='CONTA_DJS_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_declaracion_juridica','int4');
        $this->captura('descripcion','text');
        $this->captura('tipo','varchar');
        $this->captura('fila','int4');
        $this->captura('importe','numeric');
        $this->captura('codigo','varchar');
        $this->captura('estado_reg','varchar');
        $this->captura('id_gestion','int4');

        $this->captura('id_periodo','int4');
        $this->captura('fecha_reg','timestamp');
        $this->captura('usuario_ai','varchar');
        $this->captura('id_usuario_reg','int4');
        $this->captura('id_usuario_ai','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('id_usuario_mod','int4');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('estado','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarDeclaracionesJuridicas(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_declaraciones_juridicas_ime';
        $this->transaccion='CONTA_DJS_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_periodo','id_periodo','int4');
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('tipo','tipo','varchar');

        $this->setParametro('fila','fila','int4');
        $this->setParametro('descripcion','descripcion','text');
        $this->setParametro('codigo','codigo','varchar');
        $this->setParametro('importe','importe','numeric');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function eliminarFormulario(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_declaraciones_juridicas_ime';
        $this->transaccion='CONTA_DJS_DEL';
        $this->tipo_procedimiento='IME';
        //Define los parametros para la funcion
        $this->setParametro('id_periodo','id_periodo','int4');
        $this->setParametro('tipo','tipo','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function validarFormulario(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_declaraciones_juridicas_ime';
        $this->transaccion='CONTA_DJS_VAL';
        $this->tipo_procedimiento='IME';
        //Define los parametros para la funcion
        $this->setParametro('id_periodo','id_periodo','int4');
        $this->setParametro('tipo','tipo','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarDeclaracionesCodigo(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_declaraciones_juridicas_sel';
        $this->transaccion='CONTA_DJS_COM';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);
        //Definicion de la lista del resultado del query
        $this->captura('codigo','varchar');
        $this->captura('descripcion','text');
        $this->captura('fila','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
}
?>