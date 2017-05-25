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
		
		$this->captura('primaria','varchar');
		$this->captura('otros_campos','varchar');
		$this->captura('nom_fk_tabla_maestro','varchar');
		$this->captura('campo_partida_ejecucion','text');
		$this->captura('descripcion','varchar');
		$this->captura('campo_monto_pres','varchar');
		$this->captura('id_detalle_plantilla_fk','integer');
		$this->captura('forma_calculo_monto','varchar');
		$this->captura('func_act_transaccion','varchar');
		$this->captura('campo_id_tabla_detalle','varchar');
		$this->captura('rel_dev_pago','varchar');
		$this->captura('campo_trasaccion_dev','TEXT');
		$this->captura('descripcion_base','varchar');
		$this->captura('campo_id_cuenta_bancaria','varchar');
		$this->captura('campo_id_cuenta_bancaria_mov','varchar');
		$this->captura('campo_nro_cheque','varchar');
		
		$this->captura('campo_nro_cuenta_bancaria_trans','varchar');
		$this->captura('campo_porc_monto_excento_var','varchar');
		$this->captura('campo_nombre_cheque_trans','varchar');
		
		$this->captura('prioridad_documento','integer');
		$this->captura('campo_orden_trabajo','varchar');
		$this->captura('campo_forma_pago','varchar');
		$this->captura('codigo','varchar');
		
		$this->captura('tipo_relacion_contable_cc','varchar');
		$this->captura('campo_relacion_contable_cc','text');
		$this->captura('campo_suborden','varchar');
		
		
	
		
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
		$this->setParametro('aplicar_documento','aplicar_documento','varchar');
		$this->setParametro('campo_centro_costo','campo_centro_costo','consulta_select');
		$this->setParametro('campo_auxiliar','campo_auxiliar','consulta_select');
		$this->setParametro('campo_fecha','campo_fecha','consulta_select');
		$this->setParametro('estado_reg','estado_reg','varchar');
		
		
		$this->setParametro('primaria','primaria','consulta_select');
		$this->setParametro('otros_campos','otros_campos','consulta_select');
		$this->setParametro('nom_fk_tabla_maestro','nom_fk_tabla_maestro','consulta_select');
		$this->setParametro('campo_partida_ejecucion','campo_partida_ejecucion','consulta_select');
		$this->setParametro('descripcion','descripcion','consulta_select');
		$this->setParametro('campo_monto_pres','campo_monto_pres','consulta_select');
		$this->setParametro('id_detalle_plantilla_fk','id_detalle_plantilla_fk','int4');
		$this->setParametro('forma_calculo_monto','forma_calculo_monto','consulta_select');
		$this->setParametro('func_act_transaccion','func_act_transaccion','consulta_select');
		$this->setParametro('campo_id_tabla_detalle','campo_id_tabla_detalle','consulta_select');
		$this->setParametro('rel_dev_pago','rel_dev_pago','consulta_select');
		$this->setParametro('campo_trasaccion_dev','campo_trasaccion_dev','consulta_select');
		$this->setParametro('campo_id_cuenta_bancaria','campo_id_cuenta_bancaria','consulta_select');
		$this->setParametro('campo_id_cuenta_bancaria_mov','campo_id_cuenta_bancaria_mov','consulta_select');
		$this->setParametro('campo_nro_cheque','campo_nro_cheque','consulta_select');
		
		$this->setParametro('campo_nro_cuenta_bancaria_trans','campo_nro_cuenta_bancaria_trans','consulta_select');
        $this->setParametro('campo_porc_monto_excento_var','campo_porc_monto_excento_var','consulta_select');
        $this->setParametro('campo_nombre_cheque_trans','campo_nombre_cheque_trans','consulta_select');
		$this->setParametro('prioridad_documento','prioridad_documento','integer');
		$this->setParametro('campo_orden_trabajo','campo_orden_trabajo','varchar');
		$this->setParametro('campo_forma_pago','campo_forma_pago','varchar');
		$this->setParametro('codigo','codigo','varchar');
		
		$this->setParametro('tipo_relacion_contable_cc','tipo_relacion_contable_cc','varchar');
		$this->setParametro('campo_relacion_contable_cc','campo_relacion_contable_cc','varchar');
		
		$this->setParametro('campo_suborden','campo_suborden','varchar');
		
		
        

		 
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
		$this->setParametro('aplicar_documento','aplicar_documento','varchar');
		$this->setParametro('campo_centro_costo','campo_centro_costo','consulta_select');
		$this->setParametro('campo_auxiliar','campo_auxiliar','consulta_select');
		$this->setParametro('campo_fecha','campo_fecha','consulta_select');
		$this->setParametro('estado_reg','estado_reg','varchar');
		
		$this->setParametro('primaria','primaria','consulta_select');
        $this->setParametro('otros_campos','otros_campos','consulta_select');
        $this->setParametro('nom_fk_tabla_maestro','nom_fk_tabla_maestro','consulta_select');
        $this->setParametro('campo_partida_ejecucion','campo_partida_ejecucion','consulta_select');
        $this->setParametro('descripcion','descripcion','consulta_select');
        $this->setParametro('campo_monto_pres','campo_monto_pres','consulta_select');
        $this->setParametro('id_detalle_plantilla_fk','id_detalle_plantilla_fk','int4');
        $this->setParametro('forma_calculo_monto','forma_calculo_monto','consulta_select');
        $this->setParametro('func_act_transaccion','func_act_transaccion','consulta_select');
        $this->setParametro('campo_id_tabla_detalle','campo_id_tabla_detalle','consulta_select');
        $this->setParametro('rel_dev_pago','rel_dev_pago','consulta_select');
        $this->setParametro('campo_trasaccion_dev','campo_trasaccion_dev','consulta_select');
		$this->setParametro('campo_id_cuenta_bancaria','campo_id_cuenta_bancaria','consulta_select');
		$this->setParametro('campo_id_cuenta_bancaria_mov','campo_id_cuenta_bancaria_mov','consulta_select');
        $this->setParametro('campo_nro_cheque','campo_nro_cheque','consulta_select');
        $this->setParametro('campo_nro_cuenta_bancaria_trans','campo_nro_cuenta_bancaria_trans','consulta_select');
        $this->setParametro('campo_porc_monto_excento_var','campo_porc_monto_excento_var','consulta_select');
        $this->setParametro('campo_nombre_cheque_trans','campo_nombre_cheque_trans','consulta_select');
        $this->setParametro('prioridad_documento','prioridad_documento','integer');
		$this->setParametro('campo_orden_trabajo','campo_orden_trabajo','varchar');
        $this->setParametro('campo_forma_pago','campo_forma_pago','varchar');
		$this->setParametro('codigo','codigo','varchar');
		
		$this->setParametro('tipo_relacion_contable_cc','tipo_relacion_contable_cc','varchar');
		$this->setParametro('campo_relacion_contable_cc','campo_relacion_contable_cc','varchar');
		
		$this->setParametro('campo_suborden','campo_suborden','varchar');
		

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