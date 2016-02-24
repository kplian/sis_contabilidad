<?php
/**
*@package pXP
*@file gen-MODTipoDocCompraVenta.php
*@author  (admin)
*@date 22-02-2016 16:19:51
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTipoDocCompraVenta extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTipoDocCompraVenta(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_tipo_doc_compra_venta_sel';
		$this->transaccion='CONTA_TDOC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_doc_compra_venta','int4');
		$this->captura('codigo','varchar');
		$this->captura('tipo','varchar');
		$this->captura('obs','varchar');
		$this->captura('nombre','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTipoDocCompraVenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_tipo_doc_compra_venta_ime';
		$this->transaccion='CONTA_TDOC_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoDocCompraVenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_tipo_doc_compra_venta_ime';
		$this->transaccion='CONTA_TDOC_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_doc_compra_venta','id_tipo_doc_compra_venta','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoDocCompraVenta(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_tipo_doc_compra_venta_ime';
		$this->transaccion='CONTA_TDOC_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_doc_compra_venta','id_tipo_doc_compra_venta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>