<?php
/**
*@package pXP
*@file ACTOrdenTrabajo.php
*@author  Gonzalo Sarmiento Sejas
*@date 21-02-2013 21:08:55
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTOrdenTrabajo extends ACTbase{    
			
	function listarOrdenTrabajo(){
		$this->objParam->defecto('ordenacion','id_orden_trabajo');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('filtro_ot')=='listado'){
			
			if($this->objParam->getParametro('id_grupo_ots')!=''){
               $this->objParam->addFiltro("''{".$this->objParam->getParametro('id_grupo_ots')."}''::integer[] && odt.id_grupo_ots");    
			}
		}
		
		if($this->objParam->getParametro('fecha_solicitud')!=''){
            $this->objParam->addFiltro("odt.fecha_inicio <=''".$this->objParam->getParametro('fecha_solicitud')."'' and (odt.fecha_final is null or odt.fecha_final >= ''". $this->objParam->getParametro('fecha_solicitud') ."'')");    
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODOrdenTrabajo','listarOrdenTrabajo');
		} else{
			$this->objFunc=$this->create('MODOrdenTrabajo');
			
			$this->res=$this->objFunc->listarOrdenTrabajo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

   function listarOrdenTrabajoAll(){
		$this->objParam->defecto('ordenacion','id_orden_trabajo');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('filtro_ot')=='listado'){
			
			if($this->objParam->getParametro('id_grupo_ots')!=''){
               $this->objParam->addFiltro("''{".$this->objParam->getParametro('id_grupo_ots')."}''::integer[] && odt.id_grupo_ots");    
			}
		}
		
		if($this->objParam->getParametro('fecha_solicitud')!=''){
            $this->objParam->addFiltro("odt.fecha_inicio <=''".$this->objParam->getParametro('fecha_solicitud')."'' and (odt.fecha_final is null or odt.fecha_final >= ''". $this->objParam->getParametro('fecha_solicitud') ."'')");    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODOrdenTrabajo','listarOrdenTrabajoAll');
		} else{
			$this->objFunc=$this->create('MODOrdenTrabajo');
			
			$this->res=$this->objFunc->listarOrdenTrabajoAll($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}



				
	function insertarOrdenTrabajo(){
		$this->objFunc=$this->create('MODOrdenTrabajo');	
		if($this->objParam->insertar('id_orden_trabajo')){
			$this->res=$this->objFunc->insertarOrdenTrabajo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarOrdenTrabajo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarOrdenTrabajo(){
			$this->objFunc=$this->create('MODOrdenTrabajo');	
		$this->res=$this->objFunc->eliminarOrdenTrabajo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function listarOrdenTrabajoArb(){
        
        //obtiene el parametro nodo enviado por la vista
        $node=$this->objParam->getParametro('node');

        $id_cuenta=$this->objParam->getParametro('id_orden_trabajo');
        $tipo_nodo=$this->objParam->getParametro('tipo_nodo');
        
                   
        if($node=='id'){
            $this->objParam->addParametro('id_padre','%');
        }
        else {
            $this->objParam->addParametro('id_padre',$id_orden_trabajo);
        }
        
		$this->objFunc=$this->create('MODOrdenTrabajo');
        $this->res=$this->objFunc->listarOrdenTrabajoArb();
        
        $this->res->setTipoRespuestaArbol();
        
        $arreglo=array();
        
        array_push($arreglo,array('nombre'=>'id','valor'=>'id_orden_trabajo'));
        array_push($arreglo,array('nombre'=>'id_p','valor'=>'id_orden_trabajo_arb'));
        
        
        array_push($arreglo,array('nombre'=>'text','valores'=>'<b> #nro_cuenta# - #nombre_cuenta#</b>'));
        array_push($arreglo,array('nombre'=>'cls','valor'=>'nombre_cuenta'));
        array_push($arreglo,array('nombre'=>'qtip','valores'=>'<b> #nro_cuenta#</b><br/><b> #nombre_cuenta#</b><br> #desc_cuenta#'));
        
        
        $this->res->addNivelArbol('tipo_nodo','raiz',array('leaf'=>false,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'cls'=>'folder',
                                                        'tipo_nodo'=>'raiz',
                                                        'icon'=>'../../../lib/imagenes/a_form.png'),
                                                        $arreglo);
         
        /*se ande un nivel al arbol incluyendo con tido de nivel carpeta con su arreglo de equivalencias
          es importante que entre los resultados devueltos por la base exista la variable\
          tipo_dato que tenga el valor en texto = 'hoja' */
                                                                

         $this->res->addNivelArbol('tipo_nodo','hijo',array(
                                                        'leaf'=>false,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'tipo_nodo'=>'hijo',
                                                        'icon'=>'../../../lib/imagenes/a_form.png'),
                                                        $arreglo);
														
		
		$this->res->addNivelArbol('tipo_nodo','hoja',array(
                                                        'leaf'=>true,
                                                        'allowDelete'=>true,
                                                        'allowEdit'=>true,
                                                        'tipo_nodo'=>'hoja',
                                                        'icon'=>'../../../lib/imagenes/a_table_gear.png'),
                                                        $arreglo);												
														

        $this->res->imprimirRespuesta($this->res->generarJson());         

 }

function insertarOrdenTrabajoArb(){
		$this->objFunc=$this->create('MODOrdenTrabajo');	
		if($this->objParam->insertar('id_orden_trabajo')){
			$this->res=$this->objFunc->insertarOrdenTrabajoArb($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarOrdenTrabajoArb($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>