<?php
/**
*@package pXP
*@file gen-MODDocConcepto.php
*@author  (admin)
*@date 15-09-2015 13:09:45
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODDocConcepto extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarDocConcepto(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_doc_concepto_sel';
		$this->transaccion='CONTA_DOCC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_doc_concepto','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_orden_trabajo','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('id_concepto_ingas','int4');
		$this->captura('descripcion','text');
		$this->captura('cantidad_sol','numeric');
		$this->captura('precio_unitario','numeric');
		$this->captura('precio_total','numeric');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('id_doc_compra_venta','int4');		
		
		$this->captura('desc_centro_costo','TEXT');
		$this->captura('desc_concepto_ingas','VARCHAR');
		$this->captura('desc_orden_trabajo','VARCHAR');
		$this->captura('id_presupuesto','int4');
		$this->captura('precio_total_final','numeric');
		$this->captura('desc_partida','varchar');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarDocConcepto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_doc_concepto_ime';
		$this->transaccion='CONTA_DOCC_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('descripcion','descripcion','text');
		$this->setParametro('cantidad','cantidad','numeric');
		$this->setParametro('precio_unitario','precio_unitario','numeric');
		$this->setParametro('precio_total','precio_total','numeric');
		
		$this->setParametro('precio_total_final','precio_total_final','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarDocConcepto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_doc_concepto_ime';
		$this->transaccion='CONTA_DOCC_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_doc_concepto','id_doc_concepto','int4');
		$this->setParametro('id_doc_compra_venta','id_doc_compra_venta','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_orden_trabajo','id_orden_trabajo','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');
		$this->setParametro('descripcion','descripcion','text');
		$this->setParametro('cantidad','cantidad','numeric');
		$this->setParametro('precio_unitario','precio_unitario','numeric');
		$this->setParametro('precio_total','precio_total','numeric');
		$this->setParametro('precio_total_final','precio_total_final','numeric');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarDocConcepto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_doc_concepto_ime';
		$this->transaccion='CONTA_DOCC_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_doc_concepto','id_doc_concepto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function verificarRelacionConcepto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento = 'conta.ft_doc_concepto_ime';
		$this->transaccion = 'CONTA_VERCONCEP_IME';
		$this->tipo_procedimiento = 'IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('relacion','relacion','varchar');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_concepto_ingas','id_concepto_ingas','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	
			
}
?>