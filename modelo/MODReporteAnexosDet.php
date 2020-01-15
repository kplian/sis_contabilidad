<?php
/**
*@package pXP
*@file gen-MODReporteAnexosDet.php
*@author  (miguel.mamani)
*@date 10-06-2019 21:31:07
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODReporteAnexosDet extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarReporteAnexosDet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_reporte_anexos_det_sel';
		$this->transaccion='CONTA_RAD_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_reporte_anexos_det','int4');
		$this->captura('cuenta','varchar');
		$this->captura('operacion','varchar');
		$this->captura('partida','varchar');
		$this->captura('desglosar','varchar');
		$this->captura('cierre','varchar');
		$this->captura('formula','text');
		$this->captura('tipo_cuenta','varchar');
		$this->captura('ordernar','numeric');
		$this->captura('apertura','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('titulo','varchar');
		$this->captura('numero','varchar');
		$this->captura('codigo','varchar');
		$this->captura('tipo_periodo','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('id_reporte_anexos','int4');
        $this->captura('cbte_aitb','varchar');
        $this->captura('visible','varchar');
        $this->captura('id_impuesto_form','int4');
        $this->captura('id_impuesto_form_cod','int4');
        $this->captura('nombre','varchar');
        $this->captura('codigo_impuesto','varchar');
        $this->captura('mostrar_formula','varchar');
        $this->captura('id_fila','int4');
        $this->captura('codigo_fila','text');
        //Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarReporteAnexosDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_reporte_anexos_det_ime';
		$this->transaccion='CONTA_RAD_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('cuenta','cuenta','varchar');
		$this->setParametro('operacion','operacion','varchar');
		$this->setParametro('partida','partida','varchar');
		$this->setParametro('desglosar','desglosar','varchar');
		$this->setParametro('cierre','cierre','varchar');
		$this->setParametro('formula','formula','text');
		$this->setParametro('tipo_cuenta','tipo_cuenta','varchar');
		$this->setParametro('ordernar','ordernar','numeric');
		$this->setParametro('apertura','apertura','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('titulo','titulo','varchar');
		$this->setParametro('numero','numero','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('tipo_periodo','tipo_periodo','varchar');
		$this->setParametro('id_reporte_anexos','id_reporte_anexos','int4');
        $this->setParametro('cbte_aitb','cbte_aitb','varchar');
        $this->setParametro('visible','visible','varchar');
        $this->setParametro('id_impuesto_form','id_impuesto_form','int4');
        $this->setParametro('id_impuesto_form_cod','id_impuesto_form_cod','int4');
        $this->setParametro('mostrar_formula','mostrar_formula','varchar');
        $this->setParametro('id_fila','id_fila','int4');


        //Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarReporteAnexosDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_reporte_anexos_det_ime';
		$this->transaccion='CONTA_RAD_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_reporte_anexos_det','id_reporte_anexos_det','int4');
		$this->setParametro('cuenta','cuenta','varchar');
		$this->setParametro('operacion','operacion','varchar');
		$this->setParametro('partida','partida','varchar');
		$this->setParametro('desglosar','desglosar','varchar');
		$this->setParametro('cierre','cierre','varchar');
		$this->setParametro('formula','formula','text');
		$this->setParametro('tipo_cuenta','tipo_cuenta','varchar');
		$this->setParametro('ordernar','ordernar','numeric');
		$this->setParametro('apertura','apertura','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('titulo','titulo','varchar');
		$this->setParametro('numero','numero','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('tipo_periodo','tipo_periodo','varchar');
        $this->setParametro('id_reporte_anexos','id_reporte_anexos','int4');
        $this->setParametro('cbte_aitb','cbte_aitb','varchar');
        $this->setParametro('visible','visible','varchar');
        $this->setParametro('id_impuesto_form','id_impuesto_form','int4');
        $this->setParametro('id_impuesto_form_cod','id_impuesto_form_cod','int4');
        $this->setParametro('mostrar_formula','mostrar_formula','varchar');
        $this->setParametro('id_fila','id_fila','int4');

        //Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarReporteAnexosDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_reporte_anexos_det_ime';
		$this->transaccion='CONTA_RAD_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_reporte_anexos_det','id_reporte_anexos_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>