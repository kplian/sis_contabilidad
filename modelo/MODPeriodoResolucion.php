<?php
/**
*@package pXP
*@file gen-MODPeriodoResolucion.php
*@author  (miguel.mamani)
*@date 27-06-2017 21:35:54
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPeriodoResolucion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPeriodoResolucion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_periodo_resolucion_sel';
		$this->transaccion='CONTA_PRN_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_periodo_resolucion','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('estado','varchar');
		$this->captura('id_periodo','int4');
		$this->captura('id_depto','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
        $this->captura('id_gestion','int4');
        $this->captura('periodo','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

    function generarPeriodosCompraVenta(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_periodo_resolucion_ime';
        $this->transaccion='CONTA_PRN_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_depto','id_depto','int4');
        $this->setParametro('id_gestion','id_gestion','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function cerrarAbrirPeriodo(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_periodo_resolucion_ime';
        $this->transaccion='CONTA_PRN_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_periodo_resolucion','id_periodo_resolucion','int4');
        $this->setParametro('tipo','tipo','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>