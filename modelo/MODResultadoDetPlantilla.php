<?php
/**
*@package pXP
*@file gen-MODResultadoDetPlantilla.php
*@author  (admin)
*@date 08-07-2015 13:13:15
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODResultadoDetPlantilla extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarResultadoDetPlantilla(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_resultado_det_plantilla_sel';
		$this->transaccion='CONTA_RESDET_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_resultado_det_plantilla','int4');
		$this->captura('orden','numeric');
		$this->captura('font_size','varchar');
		$this->captura('formula','varchar');
		$this->captura('subrayar','varchar');
		$this->captura('codigo','varchar');
		$this->captura('montopos','int4');
		$this->captura('nombre_variable','varchar');
		$this->captura('posicion','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('nivel_detalle','int4');
		$this->captura('origen','varchar');
		$this->captura('signo','varchar');
		$this->captura('codigo_cuenta','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('id_resultado_plantilla','int4');
		
		$this->captura('visible','varchar');
		$this->captura('incluir_apertura','varchar');
		$this->captura('incluir_cierre','varchar');
		$this->captura('desc_cuenta','varchar');
		
		$this->captura('negrita','varchar');
		$this->captura('cursiva','varchar');
		$this->captura('espacio_previo','int4');
		$this->captura('incluir_aitb','varchar');
		$this->captura('tipo_saldo','varchar');
		$this->captura('signo_balance','varchar');
		
		$this->captura('relacion_contable','varchar');
		$this->captura('codigo_partida','varchar');
		$this->captura('id_auxiliar','int4');
		$this->captura('destino','varchar');
		$this->captura('orden_cbte','numeric');
		$this->captura('desc_auxiliar','varchar');
		$this->captura('desc_partida','varchar');
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarResultadoDetPlantilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_resultado_det_plantilla_ime';
		$this->transaccion='CONTA_RESDET_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_resultado_plantilla','id_resultado_plantilla','int4');
		$this->setParametro('orden','orden','numeric');
		$this->setParametro('font_size','font_size','varchar');
		$this->setParametro('formula','formula','varchar');
		$this->setParametro('subrayar','subrayar','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('montopos','montopos','int4');
		$this->setParametro('nombre_variable','nombre_variable','varchar');
		$this->setParametro('posicion','posicion','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nivel_detalle','nivel_detalle','int4');
		$this->setParametro('origen','origen','varchar');
		$this->setParametro('signo','signo','varchar');
		$this->setParametro('codigo_cuenta','codigo_cuenta','varchar');
		
		$this->setParametro('visible','visible','varchar');
		$this->setParametro('incluir_cierre','incluir_cierre','varchar');
		$this->setParametro('incluir_apertura','incluir_apertura','varchar');
		
		$this->setParametro('negrita','negrita','varchar');
		$this->setParametro('cursiva','cursiva','varchar');
		$this->setParametro('espacio_previo','espacio_previo','int4');
		$this->setParametro('incluir_aitb','incluir_aitb','varchar');
		$this->setParametro('tipo_saldo','tipo_saldo','varchar');
		$this->setParametro('signo_balance','signo_balance','varchar');
		
		$this->setParametro('relacion_contable','relacion_contable','varchar');
		$this->setParametro('codigo_partida','codigo_partida','varchar');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('destino','destino','varchar');
		$this->setParametro('orden_cbte','orden_cbte','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarResultadoDetPlantilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_resultado_det_plantilla_ime';
		$this->transaccion='CONTA_RESDET_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_resultado_det_plantilla','id_resultado_det_plantilla','int4');
		$this->setParametro('id_resultado_plantilla','id_resultado_plantilla','int4');
		$this->setParametro('orden','orden','numeric');
		$this->setParametro('font_size','font_size','varchar');
		$this->setParametro('formula','formula','varchar');
		$this->setParametro('subrayar','subrayar','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('montopos','montopos','int4');
		$this->setParametro('nombre_variable','nombre_variable','varchar');
		$this->setParametro('posicion','posicion','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nivel_detalle','nivel_detalle','int4');
		$this->setParametro('origen','origen','varchar');
		$this->setParametro('signo','signo','varchar');
		$this->setParametro('codigo_cuenta','codigo_cuenta','varchar');
		$this->setParametro('visible','visible','varchar');
		$this->setParametro('incluir_cierre','incluir_cierre','varchar');
		$this->setParametro('incluir_apertura','incluir_apertura','varchar');
		$this->setParametro('negrita','negrita','varchar');
		$this->setParametro('cursiva','cursiva','varchar');
		$this->setParametro('espacio_previo','espacio_previo','int4');
		$this->setParametro('incluir_aitb','incluir_aitb','varchar');
		$this->setParametro('tipo_saldo','tipo_saldo','varchar');
		$this->setParametro('signo_balance','signo_balance','varchar');
		$this->setParametro('relacion_contable','relacion_contable','varchar');
		$this->setParametro('codigo_partida','codigo_partida','varchar');
		$this->setParametro('id_auxiliar','id_auxiliar','int4');
		$this->setParametro('destino','destino','varchar');
		$this->setParametro('orden_cbte','orden_cbte','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarResultadoDetPlantilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_resultado_det_plantilla_ime';
		$this->transaccion='CONTA_RESDET_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_resultado_det_plantilla','id_resultado_det_plantilla','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>