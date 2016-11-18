<font size="9"><table width="100%" cellpadding="5px"  rules="cols" border="1">
<tr>
		    <td width="<?php  echo $with_col; ?>" ><div>
				<b>CC:</b> <?php  echo  $val['cc']; ?> 
			<?php if  ($val['codigo_partida']!=''){ ?>	
	   			<br/><b>Ptda.:</b> <?php  echo $val['codigo_partida'].'-'.$val['nombre_partida']; ?>
	   		<?php } ?>		
	   			<br/><b>Cta.:</b> <?php  echo $val['nro_cuenta'].' - '.$val['nombre_cuenta']; ?>
	   		<?php if  ($val['codigo_auxiliar']!=''){ ?>	
	   			<br/><b>Aux.:</b> <?php  echo $val['codigo_auxiliar'].' - '.$val['nombre_auxiliar']; ?>
	   		<?php } ?>	
	   		
	   		<?php if  ($val['desc_orden']!=''){ ?>	
	   			<br/><b>OT.:</b> <?php  echo $val['desc_orden']; ?>
	   		<?php } ?>	
	   		<?php if  ($val['glosa']!=''){ ?>	
	   		    <br/><?php  echo trim($val['glosa']); ?>
	   		<?php } ?>	</div>
			</td>
			
		<?php 
		  if ($this->cabecera[0]['id_moneda'] == $this->cabecera[0]['id_moneda_base']){
		 ?>
			
			<td width="20%" align="right" ><span><?php  if ($val['importe_debe']>0) {echo  number_format($val['importe_debe'], 2, '.', ',');} ?></span></td>
			<td width="20%" align="right" ><span><?php  if ($val['importe_haber']>0) {echo  number_format($val['importe_haber'], 2, '.', ',');} ?></span></td>
		<?php	
		  }
		 else{  
		?>
		    <td width="12.5%" align="right" ><span><?php  if ($val['importe_debe']>0) {echo   number_format($val['importe_debe'], 2, '.', ','); }?></span></td>
			<td width="12.5%" align="right" ><span><?php  if ($val['importe_haber']>0) {echo   number_format($val['importe_haber'], 2, '.', ',');} ?></span></td>
			<td width="12.5%" align="right" ><span><?php  if ($val['importe_debe_mb']>0) {echo   number_format($val['importe_debe_mb'], 2, '.', ',');} ?></span></td>
			<td width="12.5%" align="right" ><span><?php  if ($val['importe_haber_mb']>0) {echo   number_format($val['importe_haber_mb'], 2, '.', ',');} ?></span></td>
		
		<?php } ?>
</tr>
</table></font>