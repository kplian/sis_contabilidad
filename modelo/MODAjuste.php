<?php
/**
*@package pXP
*@file gen-MODAjuste.php
*@author  (admin)
*@date 10-12-2015 15:16:16
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODAjuste extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarAjuste(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_ajuste_sel';
		$this->transaccion='CONTA_AJT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_ajuste','int4');
		$this->captura('fecha','date');
		$this->captura('id_depto_conta','int4');
		$this->captura('estado','varchar');
		$this->captura('obs','text');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		$this->captura('codigo_depto','varchar');
		$this->captura('desc_depto','varchar');
		$this->captura('nombre_corto','varchar');
		$this->captura('tipo','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarAjuste(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_ajuste_ime';
		$this->transaccion='CONTA_AJT_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('obs','obs','text');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo','tipo','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarAjuste(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_ajuste_ime';
		$this->transaccion='CONTA_AJT_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_ajuste','id_ajuste','int4');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('obs','obs','text');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('tipo','tipo','varchar');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarAjuste(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_ajuste_ime';
		$this->transaccion='CONTA_AJT_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_ajuste','id_ajuste','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

     function generarCbte(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_ajuste_ime';
		$this->transaccion='CONTA_GENCBTE_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_ajuste','id_ajuste','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}


			
}
?>