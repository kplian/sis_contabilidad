<?php
/**
 *@package pXP
 *@file gen-MODPlantillaReporte.php
 *@author  (m.mamani)
 *@date 06-09-2018 19:52:00
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODPlantillaReporte extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarPlantillaReporte(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='conta.ft_plantilla_reporte_sel';
        $this->transaccion='CONTA_PER_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_plantilla_reporte','int4');
        $this->captura('nombre','varchar');
        $this->captura('glosa','text');
        $this->captura('modalidad','varchar');
        $this->captura('estado_reg','varchar');
        $this->captura('id_usuario_ai','int4');
        $this->captura('id_usuario_reg','int4');
        $this->captura('usuario_ai','varchar');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('codigo','varchar');
        $this->captura('nombre_func','text');
        $this->captura('visible','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarPlantillaReporte(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_plantilla_reporte_ime';
        $this->transaccion='CONTA_PER_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('nombre','nombre','varchar');
        $this->setParametro('glosa','glosa','text');
        $this->setParametro('modalidad','modalidad','varchar');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('codigo','codigo','varchar');
        $this->setParametro('nombre_func','nombre_func','text');
        $this->setParametro('visible','visible','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarPlantillaReporte(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_plantilla_reporte_ime';
        $this->transaccion='CONTA_PER_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_plantilla_reporte','id_plantilla_reporte','int4');
        $this->setParametro('nombre','nombre','varchar');
        $this->setParametro('glosa','glosa','text');
        $this->setParametro('modalidad','modalidad','varchar');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('codigo','codigo','varchar');
        $this->setParametro('nombre_func','nombre_func','text');
        $this->setParametro('visible','visible','varchar');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarPlantillaReporte(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_plantilla_reporte_ime';
        $this->transaccion='CONTA_PER_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_plantilla_reporte','id_plantilla_reporte','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarReportes (){
        $this->procedimiento='conta.ft_plantilla_reporte_sel';
        $this->transaccion='CONTA_REFI_SEL';
        $this->tipo_procedimiento='SEL';

        $this->captura('id_plantilla_reporte','int4');
        $this->captura('glosa','text');
        $this->captura('nombre','varchar');

        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>