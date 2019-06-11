<?php
/**
*@package pXP
*@file gen-MODCbteMarca.php
*@author  (egutierrez)
*@date 10-06-2019 20:02:44
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODCbteMarca extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarCbteMarca(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_cbte_marca_sel';
		$this->transaccion='CONTA_CBTEMAR_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_cbte_marca','int4');
		$this->captura('id_int_comprobante','int4');
		$this->captura('id_marca','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_ai','int4');
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
			
	function insertarCbteMarca(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_cbte_marca_ime';
		$this->transaccion='CONTA_CBTEMAR_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('id_marca','id_marca','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarCbteMarca(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_cbte_marca_ime';
		$this->transaccion='CONTA_CBTEMAR_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cbte_marca','id_cbte_marca','int4');
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('id_marca','id_marca','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarCbteMarca(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_cbte_marca_ime';
		$this->transaccion='CONTA_CBTEMAR_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cbte_marca','id_cbte_marca','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function guardarCbteMarca(){
		$this->procedimiento='conta.ft_cbte_marca_ime';
		$this->transaccion='CONTA_CBTEMGU_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_cbte_marca','id_cbte_marca','int4');
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('id_marca','id_marca','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
				
	}
			
}
?>