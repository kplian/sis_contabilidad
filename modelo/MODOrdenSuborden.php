<?php
/**
*@package pXP
*@file gen-MODOrdenSuborden.php
*@author  (admin)
*@date 15-05-2017 10:36:02
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODOrdenSuborden extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarOrdenSuborden(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_orden_suborden_sel';
		$this->transaccion='CONTA_ORSUO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_orden_suborden','int4');
		$this->captura('id_suborden','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_orden_trabajo','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_suborden','varchar');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarOrdenSuborden(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_orden_suborden_ime';
		$this->transaccion='CONTA_ORSUO_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_suborden','id_suborden','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarOrdenSuborden(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_orden_suborden_ime';
		$this->transaccion='CONTA_ORSUO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_orden_suborden','id_orden_suborden','int4');
		$this->setParametro('id_suborden','id_suborden','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarOrdenSuborden(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_orden_suborden_ime';
		$this->transaccion='CONTA_ORSUO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_orden_suborden','id_orden_suborden','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>