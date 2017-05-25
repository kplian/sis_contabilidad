<?php
/**
*@package pXP
*@file gen-MODPlanPagoDocumentoAirbp.php
*@author  (admin)
*@date 30-01-2017 13:13:21
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODPlanPagoDocumentoAirbp extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPlanPagoDocumentoAirbp(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_plan_pago_documento_airbp_sel';
		$this->transaccion='CONTA_PPDAIRBP_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_plan_pago_documento_airbp','int4');
		$this->captura('monto_fac','numeric');
		$this->captura('monto_usado','numeric');
		$this->captura('id_documento','int4');
		$this->captura('monto_disponible','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('usar','varchar');
		$this->captura('id_plan_pago','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
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
			
	function insertarPlanPagoDocumentoAirbp(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_plan_pago_documento_airbp_ime';
		$this->transaccion='CONTA_PPDAIRBP_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('monto_fac','monto_fac','numeric');
		$this->setParametro('monto_usado','monto_usado','numeric');
		$this->setParametro('id_documento','id_documento','int4');
		$this->setParametro('monto_disponible','monto_disponible','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('usar','usar','varchar');
		$this->setParametro('id_plan_pago','id_plan_pago','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPlanPagoDocumentoAirbp(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_plan_pago_documento_airbp_ime';
		$this->transaccion='CONTA_PPDAIRBP_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_plan_pago_documento_airbp','id_plan_pago_documento_airbp','int4');
		$this->setParametro('monto_fac','monto_fac','numeric');
		$this->setParametro('monto_usado','monto_usado','numeric');
		$this->setParametro('id_documento','id_documento','int4');
		$this->setParametro('monto_disponible','monto_disponible','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('usar','usar','varchar');
		$this->setParametro('id_plan_pago','id_plan_pago','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPlanPagoDocumentoAirbp(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_plan_pago_documento_airbp_ime';
		$this->transaccion='CONTA_PPDAIRBP_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_plan_pago_documento_airbp','id_plan_pago_documento_airbp','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	function relacionarFacturasAirBP(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_plan_pago_documento_airbp_ime';
		$this->transaccion='CONTA_PPDAIRBP_REL';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('gestion','gestion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>