<?php
/**
*@package pXP
*@file gen-MODEntregaDet.php
*@author  (admin)
*@date 17-11-2016 19:50:46
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODEntregaDet extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarEntregaDet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_entrega_det_sel';
		$this->transaccion='CONTA_END_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_entrega_det','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_int_comprobante','int4');
		$this->captura('id_entrega','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('nro_cbte','varchar');
        $this->captura('nro_tramite','varchar');
        $this->captura('beneficiario','varchar');
        $this->captura('desc_clase_comprobante','varchar');
        $this->captura('glosa1','varchar');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarEntregaDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_entrega_det_ime';
		$this->transaccion='CONTA_END_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('id_entrega','id_entrega','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarEntregaDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_entrega_det_ime';
		$this->transaccion='CONTA_END_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_entrega_det','id_entrega_det','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('id_entrega','id_entrega','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarEntregaDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_entrega_det_ime';
		$this->transaccion='CONTA_END_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_entrega_det','id_entrega_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>