<?php
/**
*@package pXP
*@file gen-MODResultadoDep.php
*@author  (admin)
*@date 14-07-2015 13:40:02
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODResultadoDep extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarResultadoDep(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_resultado_dep_sel';
		$this->transaccion='CONTA_RESDEP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_resultado_dep','int4');
		$this->captura('id_resultado_plantilla','int4');
		$this->captura('obs','varchar');
		$this->captura('prioridad','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_resultado_plantilla','text');
		$this->captura('id_resultado_plantilla_hijo','int4');
		
		
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarResultadoDep(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_resultado_dep_ime';
		$this->transaccion='CONTA_RESDEP_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_resultado_plantilla','id_resultado_plantilla','int4');
		$this->setParametro('id_resultado_plantilla_hijo','id_resultado_plantilla_hijo','int4');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('prioridad','prioridad','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarResultadoDep(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_resultado_dep_ime';
		$this->transaccion='CONTA_RESDEP_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_resultado_dep','id_resultado_dep','int4');
		$this->setParametro('id_resultado_plantilla','id_resultado_plantilla','int4');
		$this->setParametro('id_resultado_plantilla_hijo','id_resultado_plantilla_hijo','int4');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('prioridad','prioridad','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarResultadoDep(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_resultado_dep_ime';
		$this->transaccion='CONTA_RESDEP_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_resultado_dep','id_resultado_dep','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>