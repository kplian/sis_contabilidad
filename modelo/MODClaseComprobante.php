<?php
/**
*@package pXP
*@file gen-MODClaseComprobante.php
*@author  (admin)
*@date 27-05-2013 16:07:00
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODClaseComprobante extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarClaseComprobante(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_clase_comprobante_sel';
		$this->transaccion='CONTA_CCOM_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_clase_comprobante','int4');
		$this->captura('id_documento','int4');
		$this->captura('tipo_comprobante','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_doc','text');
		$this->captura('momento_comprometido','varchar');
		$this->captura('momento_ejecutado','varchar');
		$this->captura('momento_pagado','varchar');
		$this->captura('codigo','varchar');
		$this->captura('tiene_apertura','varchar');
		$this->captura('movimiento','varchar');
		
		
		
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarClaseComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_clase_comprobante_ime';
		$this->transaccion='CONTA_CCOM_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_documento','id_documento','int4');
		$this->setParametro('tipo_comprobante','tipo_comprobante','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('momento_comprometido','momento_comprometido','varchar');
		$this->setParametro('momento_ejecutado','momento_ejecutado','varchar');
		$this->setParametro('momento_pagado','momento_pagado','varchar');
		$this->setParametro('tiene_apertura','tiene_apertura','varchar');
		$this->setParametro('movimiento','movimiento','varchar');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarClaseComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_clase_comprobante_ime';
		$this->transaccion='CONTA_CCOM_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_clase_comprobante','id_clase_comprobante','int4');
		$this->setParametro('id_documento','id_documento','int4');
		$this->setParametro('tipo_comprobante','tipo_comprobante','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('momento_comprometido','momento_comprometido','varchar');
		$this->setParametro('momento_ejecutado','momento_ejecutado','varchar');
		$this->setParametro('momento_pagado','momento_pagado','varchar');
		$this->setParametro('tiene_apertura','tiene_apertura','varchar');
		$this->setParametro('movimiento','movimiento','varchar');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarClaseComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_clase_comprobante_ime';
		$this->transaccion='CONTA_CCOM_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_clase_comprobante','id_clase_comprobante','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>