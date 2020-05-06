<?php
/**
*@package pXP
*@file gen-MODIntComprobante.php
*@author  (admin)
*@date 29-08-2013 00:28:30
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 * 
    HISTORIAL DE MODIFICACIONES:
   	
 ISSUE        FORK			FECHA:		      AUTOR                 DESCRIPCION
   
 #0        				29-08-2013        RCM KPLIAN        		CREACION
 #2             		27-08-2018        RAC KPLIAN        		se añade trasaccion para modicar glosa
 *1A					21/08/2018		EGS				    		se creo la funcion listarIntComprobanteCombo
 #7			endeetr		27/12/2018		manuel guerra				crearon listado de tramites, y la modifiacion del nrotramite_aux
#32     ETR	    08/01/2019		    MMV			    		        Nuevo campo documento iva  si o no validar documentacion de via
#33     ETR     10/02/2019          Miguel Mamani	  		        Mostrar moneda $us en reporte comprobante
#50	    ETR		17/05/2019			manuel guerra		            agregar filtro depto
#51		ETR		17/05/2018			EGS						        se creo el campo id_int_comprobante_migrado
#55 	ETR		30/05/2019			EGS								Se agrega funcion par poder migrar comprobantes
#87		ETR	    08/01/2020	        MMV 		                    Reporte Cbte formato Excel
#108    ETR     05/03/2020          RAC KPLIAN                      agrega prioridad_depto
 */
class MODIntComprobante extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
	#7		
	function listarIntComprobante(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_comprobante_sel';
		$this->transaccion='CONTA_INCBTE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		$this->setParametro('nombreVista','nombreVista','varchar');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_int_comprobante','int4');
		$this->captura('id_clase_comprobante','int4');		
		$this->captura('id_subsistema','int4');
		$this->captura('id_depto','int4');
		$this->captura('id_moneda','int4');
		$this->captura('id_periodo','int4');
		$this->captura('id_funcionario_firma1','int4');
		$this->captura('id_funcionario_firma2','int4');
		$this->captura('id_funcionario_firma3','int4');
		$this->captura('tipo_cambio','numeric');
		$this->captura('beneficiario','varchar');
		$this->captura('nro_cbte','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('glosa1','varchar');
		$this->captura('fecha','date');
		$this->captura('glosa2','varchar');
		$this->captura('nro_tramite','varchar');
		$this->captura('momento','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_clase_comprobante','varchar');
		$this->captura('desc_subsistema','varchar');
		$this->captura('desc_depto','text');
		$this->captura('desc_moneda','text');
		$this->captura('desc_firma1','text');
		$this->captura('desc_firma2','text');
		$this->captura('desc_firma3','text');
		$this->captura('momento_comprometido','varchar');
		$this->captura('momento_ejecutado','varchar');
		$this->captura('momento_pagado','varchar');
		$this->captura('manual','varchar');
		$this->captura('id_int_comprobante_fks','text');
		$this->captura('id_tipo_relacion_comprobante','int');
		$this->captura('desc_tipo_relacion_comprobante','varchar');
		$this->captura('id_moneda_base','int4');
		$this->captura('desc_moneda_base','text');		
		$this->captura('cbte_cierre','varchar');
		$this->captura('cbte_apertura','varchar');
		$this->captura('cbte_aitb','varchar');		
		$this->captura('fecha_costo_ini','date');
        $this->captura('fecha_costo_fin','date');		
		$this->captura('tipo_cambio_2','numeric');
        $this->captura('id_moneda_tri','int4');
        $this->captura('sw_tipo_cambio','varchar');
        $this->captura('id_config_cambiaria','int4');
        $this->captura('ope_1','varchar');
        $this->captura('ope_2','varchar');
        $this->captura('desc_moneda_tri','text');		
		$this->captura('origen','varchar');
		$this->captura('localidad','varchar');		
		$this->captura('sw_editable','varchar');
		$this->captura('cbte_reversion','varchar');
		$this->captura('volcado','varchar');		
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_estado_wf','int4');		
		$this->captura('fecha_c31','date');
		$this->captura('c31','varchar');
		$this->captura('id_gestion','int4');
		$this->captura('periodo','int4');
		$this->captura('forma_cambio','varchar');
		
		$this->captura('ope_3','varchar');
		$this->captura('tipo_cambio_3','numeric');
		$this->captura('id_moneda_act','int4');
		$this->captura('nro_tramite_aux','varchar');
		$this->captura('documento_iva','varchar'); //#32
		$this->captura('id_int_comprobante_migrado','integer');//#51
        $this->captura('liquido_pagable','numeric');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->getConsulta();exit;
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

   function listarIntComprobanteWF(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_comprobante_sel';
		$this->transaccion='CONTA_INCBTEWF_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		
		$this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_int_comprobante','int4');
		$this->captura('id_clase_comprobante','int4');		
		$this->captura('id_subsistema','int4');
		$this->captura('id_depto','int4');
		$this->captura('id_moneda','int4');
		$this->captura('id_periodo','int4');
		$this->captura('id_funcionario_firma1','int4');
		$this->captura('id_funcionario_firma2','int4');
		$this->captura('id_funcionario_firma3','int4');
		$this->captura('tipo_cambio','numeric');
		$this->captura('beneficiario','varchar');
		$this->captura('nro_cbte','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('glosa1','varchar');
		$this->captura('fecha','date');
		$this->captura('glosa2','varchar');
		$this->captura('nro_tramite','varchar');
		$this->captura('momento','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_clase_comprobante','varchar');
		$this->captura('desc_subsistema','varchar');
		$this->captura('desc_depto','text');
		$this->captura('desc_moneda','text');
		$this->captura('desc_firma1','text');
		$this->captura('desc_firma2','text');
		$this->captura('desc_firma3','text');
		$this->captura('momento_comprometido','varchar');
		$this->captura('momento_ejecutado','varchar');
		$this->captura('momento_pagado','varchar');
		$this->captura('manual','varchar');
		$this->captura('id_int_comprobante_fks','text');
		$this->captura('id_tipo_relacion_comprobante','int');
		$this->captura('desc_tipo_relacion_comprobante','varchar');
		$this->captura('id_moneda_base','int4');
		$this->captura('desc_moneda_base','text');		
		$this->captura('cbte_cierre','varchar');
		$this->captura('cbte_apertura','varchar');
		$this->captura('cbte_aitb','varchar');		
		$this->captura('fecha_costo_ini','date');
        $this->captura('fecha_costo_fin','date');		
		$this->captura('tipo_cambio_2','numeric');
		$this->captura('tipo_cambio_3','numeric');
        $this->captura('id_moneda_tri','int4');
		$this->captura('id_moneda_act','int4');
        $this->captura('sw_tipo_cambio','varchar');
        $this->captura('id_config_cambiaria','int4');
        $this->captura('ope_1','varchar');
        $this->captura('ope_2','varchar');
        $this->captura('desc_moneda_tri','text');		
		$this->captura('origen','varchar');
		$this->captura('localidad','varchar');		
		$this->captura('sw_editable','varchar');
		$this->captura('cbte_reversion','varchar');
		$this->captura('volcado','varchar');		
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('fecha_c31','date');
		$this->captura('c31','varchar');
		$this->captura('id_gestion','int4');
		$this->captura('periodo','int4');
		$this->captura('forma_cambio','varchar');
        $this->captura('liquido_pagable', 'numeric');
	    $this->captura('prioridad_depto', 'integer');   //#108
		
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->getConsulta();exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

    function listarSimpleIntComprobante(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_comprobante_sel';
		$this->transaccion='CONTA_ICSIM_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_int_comprobante','int4');
		$this->captura('nro_cbte','varchar');
		$this->captura('nro_tramite','varchar');
		$this->captura('fecha','date');
		$this->captura('glosa1','varchar');
		$this->captura('glosa2','varchar');
		$this->captura('id_clase_comprobante','int4');
		$this->captura('codigo','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('desc_moneda','text');
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();		        
		$this->ejecutarConsulta();	
		//Devuelve la respuesta
		return $this->respuesta;
	}


			
	function insertarIntComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_comprobante_ime';
		$this->transaccion='CONTA_INCBTE_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_clase_comprobante','id_clase_comprobante','int4');
		$this->setParametro('id_subsistema','id_subsistema','int4');
		$this->setParametro('id_depto','id_depto','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('id_funcionario_firma1','id_funcionario_firma1','int4');
		$this->setParametro('id_funcionario_firma2','id_funcionario_firma2','int4');
		$this->setParametro('id_funcionario_firma3','id_funcionario_firma3','int4');
		$this->setParametro('tipo_cambio','tipo_cambio','numeric');
		$this->setParametro('beneficiario','beneficiario','varchar');
		$this->setParametro('nro_cbte','nro_cbte','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('glosa1','glosa1','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('glosa2','glosa2','varchar');
		$this->setParametro('nro_tramite','nro_tramite','varchar');
		$this->setParametro('momento_comprometido','momento_comprometido','varchar');
		$this->setParametro('momento_ejecutado','momento_ejecutado','varchar');
		$this->setParametro('momento_pagado','momento_pagado','varchar');		
		$this->setParametro('id_int_comprobante_fks','id_int_comprobante_fks','varchar');
		$this->setParametro('id_tipo_relacion_comprobante','id_tipo_relacion_comprobante','int4');		
		$this->setParametro('cbte_cierre','cbte_cierre','varchar');
		$this->setParametro('cbte_apertura','cbte_apertura','varchar');
		$this->setParametro('cbte_aitb','cbte_aitb','varchar');		
		$this->setParametro('fecha_costo_ini','fecha_costo_ini','date');
		$this->setParametro('fecha_costo_fin','fecha_costo_fin','date');	
		$this->setParametro('tipo_cambio_2','tipo_cambio_2','numeric');
		$this->setParametro('tipo_cambio_3','tipo_cambio_3','numeric');
		$this->setParametro('id_config_cambiaria','id_config_cambiaria','integer');
		$this->setParametro('forma_cambio','forma_cambio','varchar');
		$this->setParametro('documento_iva','documento_iva','varchar'); //#32
		
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarIntComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_comprobante_ime';
		$this->transaccion='CONTA_INCBTE_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('id_clase_comprobante','id_clase_comprobante','int4');
		$this->setParametro('id_int_comprobante_fk','id_int_comprobante_fk','int4');
		$this->setParametro('id_depto','id_depto','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('id_funcionario_firma1','id_funcionario_firma1','int4');
		$this->setParametro('id_funcionario_firma2','id_funcionario_firma2','int4');
		$this->setParametro('id_funcionario_firma3','id_funcionario_firma3','int4');
		$this->setParametro('tipo_cambio','tipo_cambio','numeric');
		$this->setParametro('beneficiario','beneficiario','varchar');
		$this->setParametro('nro_cbte','nro_cbte','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('glosa1','glosa1','varchar');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('glosa2','glosa2','varchar');
		$this->setParametro('nro_tramite','nro_tramite','varchar');
		
		$this->setParametro('momento_comprometido','momento_comprometido','varchar');
		$this->setParametro('momento_ejecutado','momento_ejecutado','varchar');
		$this->setParametro('momento_pagado','momento_pagado','varchar');
		$this->setParametro('id_int_comprobante_fks','id_int_comprobante_fks','varchar');
		$this->setParametro('id_tipo_relacion_comprobante','id_tipo_relacion_comprobante','int4');
		
		$this->setParametro('cbte_cierre','cbte_cierre','varchar');
		$this->setParametro('cbte_apertura','cbte_apertura','varchar');
		$this->setParametro('cbte_aitb','cbte_aitb','varchar');
		
		$this->setParametro('fecha_costo_ini','fecha_costo_ini','date');
		$this->setParametro('fecha_costo_fin','fecha_costo_fin','date');
		$this->setParametro('tipo_cambio_2','tipo_cambio_2','numeric');
		$this->setParametro('tipo_cambio_3','tipo_cambio_3','numeric');
		$this->setParametro('id_config_cambiaria','id_config_cambiaria','integer');
		$this->setParametro('forma_cambio','forma_cambio','varchar');
        $this->setParametro('documento_iva','documento_iva','varchar'); //#32

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarIntComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_comprobante_ime';
		$this->transaccion='CONTA_INCBTE_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    
	function validarIntComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_comprobante_ime';
		$this->transaccion='CONTA_INCBTE_VAL';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('igualar','igualar','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function generarDesdePlantilla(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.f_resultados_gen_cbte';
		$this->transaccion='CONTA_GENCBTERES_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_depto','id_depto','int4');
		$this->setParametro('id_resultado_plantilla','id_resultado_plantilla','int4');
		$this->setParametro('desde','desde','date');
		$this->setParametro('hasta','hasta','date');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	
	function listarCbteCabecera(){
			
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_comprobante_sel';
		$this->transaccion='CONTA_CABCBT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_int_comprobante','int4');
		$this->captura('id_clase_comprobante','int4');		
		$this->captura('id_subsistema','int4');
		$this->captura('id_depto','int4');
		$this->captura('id_moneda','int4');
		$this->captura('id_periodo','int4');
		$this->captura('id_funcionario_firma1','int4');
		$this->captura('id_funcionario_firma2','int4');
		$this->captura('id_funcionario_firma3','int4');
		$this->captura('tipo_cambio','numeric');
		$this->captura('beneficiario','varchar');
		$this->captura('nro_cbte','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('glosa1','varchar');
		$this->captura('fecha','date');
		$this->captura('glosa2','varchar');
		$this->captura('nro_tramite','varchar');
		$this->captura('momento','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_clase_comprobante','varchar');
		$this->captura('desc_subsistema','varchar');
		$this->captura('desc_depto','text');
		$this->captura('desc_moneda','text');
		$this->captura('desc_firma1','text');
		$this->captura('desc_firma2','text');
		$this->captura('desc_firma3','text');
		$this->captura('momento_comprometido','varchar');
		$this->captura('momento_ejecutado','varchar');
		$this->captura('momento_pagado','varchar');
		$this->captura('manual','varchar');
		$this->captura('id_int_comprobante_fks','text');
		$this->captura('id_tipo_relacion_comprobante','int');
		$this->captura('desc_tipo_relacion_comprobante','varchar');
		$this->captura('id_moneda_base','int4');
		$this->captura('codigo_moneda_base','varchar');		
		$this->captura('codigo_depto','varchar');
		$this->captura('documentos','varchar');
		$this->captura('c31','varchar');
		$this->captura('sw_tipo_cambio','varchar');
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarCbteDetalle(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_comprobante_sel';
		$this->transaccion='CONTA_DETCBT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
				
		//Definicion de la lista del resultado del query
		$this->captura('nro_cuenta','varchar');
		$this->captura('nombre_cuenta','varchar');
		$this->captura('codigo_auxiliar','varchar');
		$this->captura('nombre_auxiliar','varchar');
		$this->captura('cc','text');
		$this->captura('codigo_partida','varchar');
		$this->captura('nombre_partida','varchar'); 
		$this->captura('desc_orden','varchar');
		$this->captura('glosa','varchar');
		$this->captura('importe_gasto','numeric');
		$this->captura('importe_recurso','numeric');
		$this->captura('importe_debe','numeric');
		$this->captura('importe_haber','numeric');
		$this->captura('importe_debe_mb','numeric');
		$this->captura('importe_haber_mb','numeric');
        $this->captura('importe_debe_mt','numeric'); //#33
        $this->captura('importe_haber_mt','numeric'); //#33
        $this->captura('importe_debe_ma','numeric'); // #87
        $this->captura('importe_haber_ma','numeric'); //#87
		$this->captura('sw_movimiento','varchar');
		$this->captura('tipo_partida','varchar');
		$this->captura('tipo_cambio','numeric');
		
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->consulta;exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

   function igualarComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_comprobante_ime';
		$this->transaccion='CONTA_IGUACBTE_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

   function swEditable(){
		//swEditable de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_comprobante_ime';
		$this->transaccion='CONTA_SWEDIT_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
   
   function volcarCbte(){
		//swEditable de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_comprobante_ime';
		$this->transaccion='CONTA_VOLCARCBTE_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('sw_validar','sw_validar','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
   
   function listarCbteDependencias(){
		    //Definicion de variables para ejecucion del procedimientp
		    $this->procedimiento='conta.ft_int_comprobante_sel';
		    $this-> setCount(false);
		    $this->transaccion='CONTA_DEPCBT_SEL';
		    $this->tipo_procedimiento='SEL';//tipo de transaccion
		    
		    $id_padre = $this->objParam->getParametro('id_padre');
		    
		    $this->setParametro('id_padre','id_padre','varchar'); 
			$this->setParametro('id_int_comprobante_basico','id_int_comprobante_basico','int4'); 
			
			$this->captura('id_int_comprobante','int4');
			$this->captura('id_int_comprobante_padre','int4');
			
		    $this->captura('nro_cbte','varchar');
		    $this->captura('glosa1','varchar');
		    $this->captura('nombre','varchar');
		    $this->captura('volcado','varchar');
		    $this->captura('cbte_reversion','varchar');
			$this->captura('tipo_nodo','varchar');
			$this->captura('id_proceso_wf','int4');
			
			
			
		    //Ejecuta la instruccion
		    $this->armarConsulta();
			$this->ejecutarConsulta();
    
      return $this->respuesta;       
   }

   function siguienteEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'conta.ft_int_comprobante_ime';
        $this->transaccion = 'CD_SIGCBTE_IME';
        $this->tipo_procedimiento = 'IME';
   
        //Define los parametros para la funcion
        $this->setParametro('id_int_comprobante','id_int_comprobante','int4');
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_estado_wf_act','id_estado_wf_act','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');		
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');
		$this->setParametro('validar_doc','validar_doc','boolean');
		
		

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }


    function anteriorEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='conta.ft_int_comprobante_ime';
        $this->transaccion='CD_ANTCBTE_IME';
        $this->tipo_procedimiento='IME';                
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('estado_destino','estado_destino','varchar');		
		//Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
	
	function clonarCbte(){
		//swEditable de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_comprobante_ime';
		$this->transaccion='CONTA_CLONARCBTE_IME';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('sw_tramite','sw_tramite','varchar');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
			
	function modificarFechasCostosCbte(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_comprobante_ime';
		$this->transaccion='CONTA_UPDFECOS_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('fecha_costo_ini','fecha_costo_ini','date');
		$this->setParametro('fecha_costo_fin','fecha_costo_fin','date');
		

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

    function listarVerPresCbte(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.f_verificar_presu_cbte_sel';
		$this->transaccion='CONTA_VERPRES_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this-> setCount(false);
        $this->setTipoRetorno('record');

		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
				
		//Definicion de la lista del resultado del query
		
		$this->captura('id_ver','bigint');
		$this->captura('control_partida','VARCHAR');
		$this->captura('id_par','int4');
		$this->captura('id_agrupador','INTEGER');
		$this->captura('importe_debe','NUMERIC');
		$this->captura('importe_haber','NUMERIC');
		$this->captura('movimiento','VARCHAR');
		$this->captura('id_presupuesto','INTEGER');
		$this->captura('tipo_cambio','NUMERIC');
		$this->captura('monto_mb','NUMERIC');
		$this->captura('verificacion','VARCHAR');
		$this->captura('saldo','NUMERIC');		
		$this->captura('codigo_partida','VARCHAR');
		$this->captura('nombre_partida','VARCHAR');
		$this->captura('desc_tipo_presupuesto','VARCHAR');
		$this->captura('descripcion','VARCHAR');
		
 
		
	
		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->getConsulta();exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	//
	function listarRepIntComprobanteDiario(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_comprobante_sel';
		$this->transaccion='CONTA_REPINCBTE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);	
		//
		$this->setParametro('nombreVista','nombreVista','varchar');		
		$this->setParametro('fecIni','fecIni','date');		
		$this->setParametro('fecFin','fecFin','date');				
		//Definicion de la lista del resultado del query
		$this->captura('id_int_comprobante','int4');
		$this->captura('nro_cbte','varchar');
		$this->captura('nro_tramite','varchar');
		$this->captura('glosa1','varchar');
		$this->captura('fecha','date');
		$this->captura('glosa2','varchar');		
		$this->captura('beneficiario','varchar');
		$this->captura('c31','varchar');		
		$this->captura('fecha_costo_ini','date');
		$this->captura('fecha_costo_fin','date');
		
		$this->captura('id_depto','int4');
		$this->captura('id_gestion','int4');
		
		$this->captura('glosa','varchar');
		
		$this->captura('nombre_partida','varchar');
		$this->captura('desc_cuenta','varchar');
		$this->captura('desc_centro_costo','varchar');
		
		$this->captura('importe_debe_mb','numeric');
		$this->captura('importe_haber_mb','numeric');
		$this->captura('importe_gasto_mb','numeric');
		
		$this->captura('importe_debe_mt','numeric');
		$this->captura('importe_haber_mt','numeric');
		$this->captura('importe_gasto_mt','numeric');
		
		$this->captura('importe_debe_ma','numeric');
		$this->captura('importe_haber_ma','numeric');
		$this->captura('importe_gasto_ma','numeric');
		
		$this->armarConsulta();
		//echo $this->getConsulta();exit;
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}

	function listarIntComprobanteTCCCuenta(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_comprobante_sel';
		$this->transaccion='CONTA_CBTENCUE_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_int_comprobante','int4');
		$this->captura('fecha','date');
		$this->captura('glosa1','varchar');
		$this->captura('nro_tramite','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	//#2 RAC, 27-08-2018  se añade trasaccion para modificar glosa de comprobantes validados	
	function modificarGlosaIntComprobante(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_comprobante_ime';
		$this->transaccion='CONTA_UPDGLOSA_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('glosa1','glosa1','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	////////////EGS-F-21/08/2018///    1A	
	function listarIntComprobanteCombo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_comprobante_sel';
		$this->transaccion='CONTA_INCBTECB_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		//$this->setCount(false);	
		

		//$this->setParametro('nombreVista','nombreVista','varchar');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_int_comprobante','int4');
		$this->captura('id_clase_comprobante','int4');		
		$this->captura('id_subsistema','int4');
		$this->captura('id_depto','int4');
		$this->captura('id_moneda','int4');
		$this->captura('id_periodo','int4');
		$this->captura('id_funcionario_firma1','int4');
		$this->captura('id_funcionario_firma2','int4');
		$this->captura('id_funcionario_firma3','int4');
		$this->captura('tipo_cambio','numeric');
		$this->captura('beneficiario','varchar');
		$this->captura('nro_cbte','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('glosa1','varchar');
		$this->captura('fecha','date');
		$this->captura('glosa2','varchar');
		$this->captura('nro_tramite','varchar');
		$this->captura('momento','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_clase_comprobante','varchar');
		$this->captura('desc_subsistema','varchar');
		$this->captura('desc_depto','text');
		$this->captura('desc_moneda','text');
		$this->captura('desc_firma1','text');
		$this->captura('desc_firma2','text');
		$this->captura('desc_firma3','text');
		$this->captura('momento_comprometido','varchar');
		$this->captura('momento_ejecutado','varchar');
		$this->captura('momento_pagado','varchar');
		$this->captura('manual','varchar');
		$this->captura('id_int_comprobante_fks','text');
		$this->captura('id_tipo_relacion_comprobante','int');
		$this->captura('desc_tipo_relacion_comprobante','varchar');
		$this->captura('id_moneda_base','int4');
		$this->captura('desc_moneda_base','text');		
		$this->captura('cbte_cierre','varchar');
		$this->captura('cbte_apertura','varchar');
		$this->captura('cbte_aitb','varchar');		
		$this->captura('fecha_costo_ini','date');
        $this->captura('fecha_costo_fin','date');		
		$this->captura('tipo_cambio_2','numeric');
        $this->captura('id_moneda_tri','int4');
        $this->captura('sw_tipo_cambio','varchar');
        $this->captura('id_config_cambiaria','int4');
        $this->captura('ope_1','varchar');
        $this->captura('ope_2','varchar');
        $this->captura('desc_moneda_tri','text');		
		$this->captura('origen','varchar');
		$this->captura('localidad','varchar');		
		$this->captura('sw_editable','varchar');
		$this->captura('cbte_reversion','varchar');
		$this->captura('volcado','varchar');		
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_estado_wf','int4');		
		$this->captura('fecha_c31','date');
		$this->captura('c31','varchar');
		$this->captura('id_gestion','int4');
		$this->captura('periodo','int4');
		$this->captura('forma_cambio','varchar');
		
		$this->captura('ope_3','varchar');
		$this->captura('tipo_cambio_3','numeric');
		$this->captura('id_moneda_act','int4');
		$this->captura('movimiento','varchar');
		
		
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->getConsulta();exit;
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}

	////////////EGS-F-21/08/2018///    1A	
	
	//#50
	function listadoCbtes(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_comprobante_sel';
		$this->transaccion='CONTA_REPCBT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);	
		//
		$this->setParametro('id_usuario','id_usuario','int4');
		$this->setParametro('id_depto','id_depto','int4');		
		$this->setParametro('fecha_ini','fecha_ini','date');		
		$this->setParametro('fecha_fin','fecha_fin','date');				
		//Definicion de la lista del resultado del query
		$this->captura('id_int_comprobante','int4');
		$this->captura('beneficiario','varchar');
		$this->captura('nro_cbte','varchar');
		$this->captura('desc_clase_comprobante','varchar');
		$this->captura('periodo','int4');
		$this->captura('cbte','varchar');		
		$this->captura('cbte_m','int4');
		$this->captura('glosa1','varchar');		
		$this->captura('fecha','date');
		$this->captura('nro_tramite','varchar');		
		$this->captura('cbte_reversion','varchar');
		$this->captura('usr_reg','varchar');		
		$this->captura('fecha_reg','date');		
		$this->captura('nombre','varchar');
		
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
	//
	function modificarTramiIntCbte(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='conta.ft_int_comprobante_ime';
		$this->transaccion='CONTA_TRAMCBT_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_int_comprobante','id_int_comprobante','int4');
		$this->setParametro('nro_tramite_aux','nro_tramite_aux','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
	//#7
	function listadoTramites(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_comprobante_sel';
		$this->transaccion='CONTA_LISTRA_SEL';
		$this->tipo_procedimiento='SEL';
		//Definicion de la lista del resultado del query		
		$this->captura('id_proceso_wf','int4');
		$this->captura('nro_tramite','varchar');
							
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}
	
	function migrarComprobante(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='conta.ft_int_comprobante_ime';
		$this->transaccion='CONTA_MIGCBTE_IME';
		$this->tipo_procedimiento='IME';
		//Definicion de la lista del resultado del query		
		$this->setParametro('id_int_comprobante','id_int_comprobante','json_text');
		$this->setParametro('todo','todo','varchar');
							
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//Devuelve la respuesta
		return $this->respuesta;
	}				
}
?>