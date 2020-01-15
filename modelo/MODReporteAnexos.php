<?php
/**
*@package pXP
*@file gen-MODReporteAnexos.php
*@author  (miguel.mamani)
*@date 10-06-2019 21:31:03
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODReporteAnexos extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarReporteAnexos(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_reporte_anexos_sel';
		$this->transaccion='CONTA_RAS_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_reporte_anexos','int4');
		$this->captura('titulo','varchar');
		$this->captura('funcion','varchar');
		$this->captura('codigo','varchar');
		$this->captura('nombre_funcion','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('header','varchar');
		$this->captura('visible','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
        $this->captura('ordenar','int4');
        $this->captura('tipo','varchar');
        $this->captura('id_gestion','int4');

        //Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarReporteAnexos(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_reporte_anexos_ime';
		$this->transaccion='CONTA_RAS_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('titulo','titulo','varchar');
		$this->setParametro('funcion','funcion','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre_funcion','nombre_funcion','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('header','header','varchar');
		$this->setParametro('visible','visible','varchar');
		$this->setParametro('ordenar','ordenar','int4');
		$this->setParametro('tipo','tipo','varchar');
        $this->setParametro('id_gestion','id_gestion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarReporteAnexos(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_reporte_anexos_ime';
		$this->transaccion='CONTA_RAS_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_reporte_anexos','id_reporte_anexos','int4');
		$this->setParametro('titulo','titulo','varchar');
		$this->setParametro('funcion','funcion','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre_funcion','nombre_funcion','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('header','header','varchar');
		$this->setParametro('visible','visible','varchar');
        $this->setParametro('ordenar','ordenar','int4');
        $this->setParametro('tipo','tipo','varchar');
        $this->setParametro('id_gestion','id_gestion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarReporteAnexos(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_reporte_anexos_ime';
		$this->transaccion='CONTA_RAS_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_reporte_anexos','id_reporte_anexos','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
    function ReporteAnexosPlantillas(){
        $this->procedimiento='conta.f_reporte_anexos_generar';
        $this->transaccion='CONTA_REAN_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setTipoRetorno('record');
        $this-> setCount(false);
        //paramtros
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('id_reporte_anexos','id_reporte_anexos','int');

        $this->captura('id','int4');
        $this->captura('id_reporte_anexos','int4');
        $this->captura('gestion','int4');
        $this->captura('cabecera','varchar');
        $this->captura('codigo','varchar');
        $this->captura('titulo','varchar');
        $this->captura('tipo_reporte','varchar');
        $this->captura('numero','varchar');
        $this->captura('nombre','varchar');
        $this->captura('codigo_det','varchar');
        $this->captura('periodo','int4');
        $this->captura('nombre_fila','varchar');
        $this->captura('importe','numeric');
        $this->captura('ordenar','int4');
        $this->captura('desglosar','varchar');
        $this->captura('origen','varchar');
        $this->captura('codigo_formula','varchar');
        $this->captura('codigo_nombre','varchar');
        $this->captura('subtitulo','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        /*echo $this->getConsulta();
        exit;*/
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function DesgrosarAnexosPlantillas(){
        $this->procedimiento='conta.f_reporte_anexos_generar';
        $this->transaccion='CONTA_GLO_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setTipoRetorno('record');
        $this-> setCount(false);
        //paramtros
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('id_reporte_anexos','id_reporte_anexos','int');

        $this->captura('nro_cuenta','varchar');
        $this->captura('codigo','varchar');
        $this->captura('importe','numeric');
        //Ejecuta la instruccion
        $this->armarConsulta();
        /*echo $this->getConsulta();
        exit;*/
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
			
}
?>