<?php
/**
*@package pXP
*@file gen-MODAgrupador.php
*@author  (admin)
*@date 22-09-2015 16:47:53
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODAgrupador extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarAgrupador(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_agrupador_sel';
		$this->transaccion='CONTA_AGR_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_agrupador','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('fecha_ini','date');
		$this->captura('fecha_fin','date');
		$this->captura('tipo','int4');
		$this->captura('id_depto_conta','int4');
		$this->captura('id_moneda','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarAgrupador(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_agrupador_ime';
		$this->transaccion='CONTA_AGR_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('tipo','tipo','int4');
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
		$this->setParametro('id_moneda','id_moneda','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarAgrupador(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_agrupador_ime';
		$this->transaccion='CONTA_AGR_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_agrupador','id_agrupador','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('tipo','tipo','int4');
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
		$this->setParametro('id_moneda','id_moneda','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarAgrupador(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_agrupador_ime';
		$this->transaccion='CONTA_AGR_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_agrupador','id_agrupador','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function generarAgrupacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_agrupador_ime';
		$this->transaccion='CONTA_GENAGRU_IME';
		$this->tipo_procedimiento='IME';
				
		
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('id_depto_conta','id_depto_conta','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('fecha_cbte','fecha_cbte','date');
		$this->setParametro('incluir_rev','incluir_rev','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>