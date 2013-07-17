<?php
/**
*@package pXP
*@file gen-MODComprobante.php
*@author  (admin)
*@date 13-07-2013 01:56:48
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODComprobante extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarComprobante(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_comprobante_sel';
		$this->transaccion='CONTA_CBTE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_comprobante','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_funcionario_firma2','int4');
		$this->captura('id_periodo','int4');
		$this->captura('momento','varchar');
		$this->captura('tipo_cambio','numeric');
		$this->captura('id_funcionario_firma1','int4');
		$this->captura('beneficiario','varchar');
		$this->captura('id_depto','int4');
		$this->captura('glosa2','varchar');
		$this->captura('id_moneda','int4');
		$this->captura('id_funcionario_firma3','int4');
		$this->captura('glosa1','varchar');
		$this->captura('id_clase_comprobante','int4');
		$this->captura('id_subsistema','int4');
		$this->captura('nro_cbte','varchar');
		$this->captura('id_comprobante_fk','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('fecha','date');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_comprobante_ime';
		$this->transaccion='CONTA_CBTE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_funcionario_firma2','id_funcionario_firma2','int4');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('momento','momento','varchar');
		$this->setParametro('tipo_cambio','tipo_cambio','numeric');
		$this->setParametro('id_funcionario_firma1','id_funcionario_firma1','int4');
		$this->setParametro('beneficiario','beneficiario','varchar');
		$this->setParametro('id_depto','id_depto','int4');
		$this->setParametro('glosa2','glosa2','varchar');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_funcionario_firma3','id_funcionario_firma3','int4');
		$this->setParametro('glosa1','glosa1','varchar');
		$this->setParametro('id_clase_comprobante','id_clase_comprobante','int4');
		$this->setParametro('id_subsistema','id_subsistema','int4');
		$this->setParametro('nro_cbte','nro_cbte','varchar');
		$this->setParametro('id_comprobante_fk','id_comprobante_fk','int4');
		$this->setParametro('fecha','fecha','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_comprobante_ime';
		$this->transaccion='CONTA_CBTE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_comprobante','id_comprobante','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_funcionario_firma2','id_funcionario_firma2','int4');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('momento','momento','varchar');
		$this->setParametro('tipo_cambio','tipo_cambio','numeric');
		$this->setParametro('id_funcionario_firma1','id_funcionario_firma1','int4');
		$this->setParametro('beneficiario','beneficiario','varchar');
		$this->setParametro('id_depto','id_depto','int4');
		$this->setParametro('glosa2','glosa2','varchar');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_funcionario_firma3','id_funcionario_firma3','int4');
		$this->setParametro('glosa1','glosa1','varchar');
		$this->setParametro('id_clase_comprobante','id_clase_comprobante','int4');
		$this->setParametro('id_subsistema','id_subsistema','int4');
		$this->setParametro('nro_cbte','nro_cbte','varchar');
		$this->setParametro('id_comprobante_fk','id_comprobante_fk','int4');
		$this->setParametro('fecha','fecha','date');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_comprobante_ime';
		$this->transaccion='CONTA_CBTE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_comprobante','id_comprobante','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>