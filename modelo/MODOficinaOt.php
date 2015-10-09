<?php
/**
*@package pXP
*@file gen-MODOficinaOt.php
*@author  (jrivera)
*@date 09-10-2015 18:48:40
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODOficinaOt extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarOficinaOt(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_oficina_ot_sel';
		$this->transaccion='CONTA_OFOT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_oficina_ot','int4');
		$this->captura('id_oficina','int4');
		$this->captura('id_orden_trabajo','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_orden','varchar');
		$this->captura('nombre_oficina','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarOficinaOt(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_oficina_ot_ime';
		$this->transaccion='CONTA_OFOT_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_oficina','id_oficina','int4');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarOficinaOt(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_oficina_ot_ime';
		$this->transaccion='CONTA_OFOT_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_oficina_ot','id_oficina_ot','int4');
		$this->setParametro('id_oficina','id_oficina','int4');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarOficinaOt(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_oficina_ot_ime';
		$this->transaccion='CONTA_OFOT_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_oficina_ot','id_oficina_ot','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>