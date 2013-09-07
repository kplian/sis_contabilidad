<?php
/**
*@package pXP
*@file gen-MODDetallePlantillaComprobante.php
*@author  (admin)
*@date 10-06-2013 14:51:03
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODDetallePlantillaComprobante extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarDetallePlantillaComprobante(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_detalle_plantilla_comprobante_sel';
		$this->transaccion='CONTA_CMPBDET_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		$this->setParametro('id_plantilla_comprobante','id_plantilla_comprobante','int4');
		//Definicion de la lista del resultado del query
		$this->captura('id_detalle_plantilla_comprobante','int4');
		$this->captura('id_plantilla_comprobante','int4');
		$this->captura('debe_haber','varchar');
		$this->captura('agrupar','varchar');
		$this->captura('es_relacion_contable','varchar');
		$this->captura('tabla_detalle','varchar');
		$this->captura('campo_partida','text');
		$this->captura('campo_concepto_transaccion','text');
		$this->captura('tipo_relacion_contable','varchar');
		$this->captura('campo_cuenta','text');
		$this->captura('campo_monto','text');
		$this->captura('campo_relacion_contable','text');
		$this->captura('campo_documento','text');
		$this->captura('aplicar_documento','varchar');
		$this->captura('campo_centro_costo','text');
		$this->captura('campo_auxiliar','text');
		$this->captura('campo_fecha','text');
		$this->captura('estado_reg','varchar');
		$this->captura('fecha_reg','timestamp');
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
			
	function insertarDetallePlantillaComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_detalle_plantilla_comprobante_ime';
		$this->transaccion='CONTA_CMPBDET_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_plantilla_comprobante','id_plantilla_comprobante','int4');
		$this->setParametro('debe_haber','debe_haber','varchar');
		$this->setParametro('agrupar','agrupar','varchar');
		$this->setParametro('es_relacion_contable','es_relacion_contable','varchar');
		$this->setParametro('tabla_detalle','tabla_detalle','varchar');
		$this->setParametro('campo_partida','campo_partida','consulta_select');
		$this->setParametro('campo_concepto_transaccion','campo_concepto_transaccion','consulta_select');
		$this->setParametro('tipo_relacion_contable','tipo_relacion_contable','varchar');
		$this->setParametro('campo_cuenta','campo_cuenta','consulta_select');
		$this->setParametro('campo_monto','campo_monto','consulta_select');
		$this->setParametro('campo_relacion_contable','campo_relacion_contable','consulta_select');
		$this->setParametro('campo_documento','campo_documento','consulta_select');
		$this->setParametro('aplicar_documento','aplicar_documento','int4');
		$this->setParametro('campo_centro_costo','campo_centro_costo','consulta_select');
		$this->setParametro('campo_auxiliar','campo_auxiliar','consulta_select');
		$this->setParametro('campo_fecha','campo_fecha','consulta_select');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarDetallePlantillaComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_detalle_plantilla_comprobante_ime';
		$this->transaccion='CONTA_CMPBDET_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_detalle_plantilla_comprobante','id_detalle_plantilla_comprobante','int4');
		$this->setParametro('id_plantilla_comprobante','id_plantilla_comprobante','int4');
		$this->setParametro('debe_haber','debe_haber','varchar');
		$this->setParametro('agrupar','agrupar','varchar');
		$this->setParametro('es_relacion_contable','es_relacion_contable','varchar');
		$this->setParametro('tabla_detalle','tabla_detalle','varchar');
		$this->setParametro('campo_partida','campo_partida','consulta_select');
		$this->setParametro('campo_concepto_transaccion','campo_concepto_transaccion','consulta_select');
		$this->setParametro('tipo_relacion_contable','tipo_relacion_contable','varchar');
		$this->setParametro('campo_cuenta','campo_cuenta','consulta_select');
		$this->setParametro('campo_monto','campo_monto','consulta_select');
		$this->setParametro('campo_relacion_contable','campo_relacion_contable','consulta_select');
		$this->setParametro('campo_documento','campo_documento','consulta_select');
		$this->setParametro('aplicar_documento','aplicar_documento','int4');
		$this->setParametro('campo_centro_costo','campo_centro_costo','consulta_select');
		$this->setParametro('campo_auxiliar','campo_auxiliar','consulta_select');
		$this->setParametro('campo_fecha','campo_fecha','consulta_select');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarDetallePlantillaComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_detalle_plantilla_comprobante_ime';
		$this->transaccion='CONTA_CMPBDET_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_detalle_plantilla_comprobante','id_detalle_plantilla_comprobante','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>