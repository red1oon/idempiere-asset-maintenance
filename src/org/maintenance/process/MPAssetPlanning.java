/**
 * Licensed under the KARMA v.1 Law of Sharing. As others have shared freely to you, so shall you share freely back to us.
 * If you shall try to cheat and find a loophole in this license, then KARMA will exact your share.
 * and your worldly gain shall come to naught and those who share shall gain eventually above you.
 * In compliance with previous GPLv2.0 works of ComPiere USA, Ramiro Vergara, OFB Consulting, CHILE. 
 * Enhanced by Redhuan D. Oon (red1org@gmail.com). sponsored by Zeeshan@sysnova.com
*/
package org.maintenance.process;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.logging.Level;

import org.compiere.process.ProcessInfoParameter;
import org.compiere.process.SvrProcess;
import org.compiere.util.DB;
import org.maintenance.component.MMPPrognosis;

/**
 *	
 *	
 *  @author Fabian Aguilar -faaguilar
 *  @version $Id: MPAssetPlanning.java,v 1.2 2010/12/15 00:51:01  $
 */
public class MPAssetPlanning extends SvrProcess
{
	int periodNo=0;
	private int p_PInstance_ID;
	String stringDate;
	int counter=0;
	/**
	 *  Prepare - e.g., get Parameters.
	 */
	protected void prepare()
	{
		
		ProcessInfoParameter[] para = getParameter();
		for (int i = 0; i < para.length; i++)
		{
			String name = para[i].getParameterName();
			if (para[i].getParameter() == null)
				;
			else if (name.equals("PeriodNo"))
				periodNo = para[i].getParameterAsInt();
			else
				log.log(Level.SEVERE, "prepare - Unknown Parameter: " + name);
		}
		p_PInstance_ID = getAD_PInstance_ID();
		
		if(DB.isOracle())
			stringDate="SysDate";
		else
			stringDate="now()";
			
	}	//	prepare

	/**
	 *  Perrform process.
	 *  @return Message (clear text)
	 *  @throws Exception if not successful
	 */
	protected String doIt() throws Exception
	{
		
		//searching by calendar
		StringBuffer byCalendar = new StringBuffer();
		byCalendar.append("SELECT MA.AD_CLIENT_ID,MA.AD_ORG_ID,MA.MP_MAINTAIN_ID,MA.DESCRIPTION,MA.PROGRAMMINGTYPE, A.A_ASSET_ID,DATENEXTRUN ,MA.DATELASTRUN,MA.INTERVAL");
		byCalendar.append(" FROM MP_MAINTAIN MA");
		byCalendar.append(" INNER JOIN A_ASSET A ON (MA.A_ASSET_ID=A.A_ASSET_ID OR A.A_ASSET_Group_ID=MA.A_ASSET_Group_ID)");
		byCalendar.append(" WHERE PROGRAMMINGTYPE='C' AND DATENEXTRUN BETWEEN "+stringDate+"-60 AND "+stringDate+"+(7*"+ periodNo+")");
		byCalendar.append(" AND MA.DOCSTATUS<>'IT' Order by DATENEXTRUN asc");
		
		
		PreparedStatement pstmt = null;
		try
		{
			pstmt = DB.prepareStatement(byCalendar.toString(), get_TrxName());
			ResultSet rs = pstmt.executeQuery();
			while (rs.next())
			{
				Calendar datefrom = Calendar.getInstance();
				Calendar dateto = Calendar.getInstance();
				int diaA=0, diaB=7,period=1;
				int ciclo=0;
				
				while(period<=periodNo){
					
				 Timestamp currentDate=rs.getTimestamp("DATENEXTRUN");	
				 datefrom.add(Calendar.DATE, diaA*period);
				 dateto.add(Calendar.DATE, diaA*diaB);
				 
				if(currentDate.compareTo(datefrom.getTime())>=0 &&   currentDate.compareTo(dateto.getTime())<=0)
		            ciclo=period;
				
				period++;
				}
				
				/*log.info("Insertcalendar");
				StringBuffer insert=new StringBuffer();
				insert.append("INSERT INTO MP_Prognosis");
				insert.append(" VALUES ("+p_PInstance_ID+","+rs.getInt("AD_CLIENT_ID")+","+rs.getInt("AD_ORG_ID")+",'Y',"+stringDate +",100,"+stringDate +",100,");
				insert.append(rs.getInt("A_ASSET_ID")+","+rs.getInt("MP_MAINTAIN_ID")+",'Por Calendario :"+ rs.getString("DATENEXTRUN")
						+"','"+rs.getString("PROGRAMMINGTYPE")+"',"+ciclo+",to_date('"+rs.getString("DATENEXTRUN").substring(0, 10)+"','yyyy-mm-dd'),'N','N')");
				DB.executeUpdate(insert.toString(), get_TrxName());*/
				
				MMPPrognosis mp=new MMPPrognosis(getCtx(), 0, get_TrxName());
				 mp.setA_Asset_ID(rs.getInt("A_ASSET_ID"));
		            mp.setAD_Org_ID(rs.getInt("AD_ORG_ID"));
		            mp.setAD_PInstance_ID(p_PInstance_ID);
		            mp.setciclo(ciclo);
		            mp.setDateTrx(rs.getTimestamp("DATENEXTRUN"));
		            mp.setDescription("By Calendar :"+rs.getString("DATENEXTRUN"));
		            mp.setMP_Maintain_ID(rs.getInt("MP_MAINTAIN_ID"));
		            mp.setProgrammingType(rs.getString("PROGRAMMINGTYPE"));
		            mp.setselected(false);	           
		            mp.saveEx();
		            counter++;
			}
		
			rs.close();
			pstmt.close();
			pstmt = null;
			
//			commitEx();
		}
		catch (Exception e)
		{
			log.log(Level.SEVERE, e.getMessage(), e);
		}
		
		//searching by meter
		StringBuffer byMeter = new StringBuffer();
		/*byMeter.append("SELECT MA.AD_CLIENT_ID,MA.AD_ORG_ID,MA.MP_MAINTAIN_ID,MA.DESCRIPTION,MA.PROGRAMMINGTYPE, A.A_ASSET_ID,MA.MP_METER_ID, MA.RANGE, MA.NEXTMP");
		byMeter.append(" , Min(MLOG.DateTrx)as FirstDay, Max(MLOG.DateTrx)as LastDay, Sum(CurrentAmt)as Total, Count(1)as Qty,MS.MESURETYPE");
		byMeter.append(" FROM MP_MAINTAIN MA");
		byMeter.append(" INNER JOIN MP_METER MS ON (MA.MP_METER_ID=MS.MP_METER_ID)");
		byMeter.append(" INNER JOIN MP_ASSETMETER ME ON (MS.MP_METER_ID=ME.MP_METER_ID AND MA.A_ASSET_ID=ME.A_ASSET_ID)");
		byMeter.append(" INNER JOIN MP_AssetMeter_Log MLOG ON (ME.MP_ASSETMETER_ID=MLOG.MP_ASSETMETER_ID)");
		byMeter.append(" INNER JOIN A_ASSET A ON (MA.A_ASSET_ID=A.A_ASSET_ID OR A.MP_MPGroup_ID=MA.MP_MPGroup_ID)");
		byMeter.append(" WHERE PROGRAMMINGTYPE='M' AND MA.DOCSTATUS<>'IT'");
		byMeter.append(" AND Mlog.DateTrx BETWEEN (SysDate-40) AND SysDate");
		byMeter.append(" Group by MA.AD_CLIENT_ID,MA.AD_ORG_ID,MA.MP_MAINTAIN_ID,MA.DESCRIPTION,MA.PROGRAMMINGTYPE, A.A_ASSET_ID,MA.MP_METER_ID,MA.RANGE, MA.NEXTMP,MS.MESURETYPE");*/
		
		byMeter.append("SELECT MA.AD_CLIENT_ID,MA.AD_ORG_ID,MA.MP_MAINTAIN_ID,MA.DESCRIPTION,MA.PROGRAMMINGTYPE, A.A_ASSET_ID,MA.MP_METER_ID, MA.RANGE, MA.NEXTMP");
		byMeter.append(", (select MIN(log2.DateTrx) from MP_AssetMeter_Log log2 where  ME.MP_ASSETMETER_ID=log2.MP_ASSETMETER_ID");
		byMeter.append(" and log2.DateTrx BETWEEN ("+stringDate+"-40) AND "+stringDate+")as FirstDay, ");
		byMeter.append(" (select MAX(log2.DateTrx) from MP_AssetMeter_Log log2 where  ME.MP_ASSETMETER_ID=log2.MP_ASSETMETER_ID");
		byMeter.append(" and log2.DateTrx BETWEEN ("+stringDate+"-40) AND "+stringDate+") as LastDay, ");
		byMeter.append(" Count(1)as Qty,ME.MP_ASSETMETER_ID,MS.Name");
		byMeter.append(" FROM MP_MAINTAIN MA");
		byMeter.append(" INNER JOIN A_ASSET A ON (MA.A_ASSET_ID=A.A_ASSET_ID OR A.A_ASSET_Group_ID=MA.A_ASSET_Group_ID)");
		byMeter.append(" INNER JOIN MP_METER MS ON (MA.MP_METER_ID=MS.MP_METER_ID)");
		byMeter.append(" INNER JOIN MP_ASSETMETER ME ON (MS.MP_METER_ID=ME.MP_METER_ID and a.a_asset_id= me.a_asset_id)");
		byMeter.append(" INNER JOIN MP_AssetMeter_Log MLOG ON (ME.MP_ASSETMETER_ID=MLOG.MP_ASSETMETER_ID)");
		byMeter.append(" WHERE PROGRAMMINGTYPE='M' AND MA.DOCSTATUS<>'IT'");
		byMeter.append(" AND Mlog.DateTrx BETWEEN ("+stringDate+"-40) AND "+stringDate);
		byMeter.append(" Group by MA.AD_CLIENT_ID,MA.AD_ORG_ID,MA.MP_MAINTAIN_ID,MA.DESCRIPTION,MA.PROGRAMMINGTYPE, A.A_ASSET_ID,MA.MP_METER_ID,MA.RANGE, MA.NEXTMP,ME.MP_ASSETMETER_ID,MS.Name");
																								
	    
		pstmt = null;
		try
		{
			pstmt = DB.prepareStatement(byMeter.toString(), get_TrxName());
			ResultSet rs = pstmt.executeQuery();
			while (rs.next())
			{
		
				int cumple=0;
				float lastM=0,firstM=0,prom=0;
		        if(rs.getInt("Qty")>1){
		        	log.info("ReadingLastM");
		        	Object params[]=new Object[]{rs.getInt("A_ASSET_ID"),rs.getInt("MP_Meter_ID"),rs.getTimestamp("LastDay")};
		        	
		        	log.info("ReadingFirstM:"+rs.getInt("A_ASSET_ID")+"-"+rs.getInt("MP_Meter_ID")+"-"+ rs.getTimestamp("LastDay"));
		        	lastM=DB.getSQLValueBD(get_TrxName(), " SELECT mlog.CurrentAmt FROM MP_AssetMeter_Log mlog"+
		            " Inner join MP_AssetMeter met on (mlog.MP_AssetMeter_ID=met.MP_AssetMeter_ID)"+
		            " WHERE met.A_ASSET_ID=? AND met.MP_Meter_ID=? AND mlog.DATETRX=? ",params ).floatValue();
		        	
		        	log.info("ReadingFirstM:"+rs.getInt("A_ASSET_ID")+"-"+rs.getInt("MP_Meter_ID")+"-"+ rs.getTimestamp("FIRSTDAY"));
		        	
		        	params=new Object[]{rs.getInt("A_ASSET_ID"),rs.getInt("MP_Meter_ID"),rs.getTimestamp("FIRSTDAY")};
		        	firstM=DB.getSQLValueBD(get_TrxName(),"SELECT mlog.CurrentAmt "+
		                    " FROM MP_AssetMeter_Log mlog"+
		                    " Inner join MP_AssetMeter met on (mlog.MP_AssetMeter_ID=met.MP_AssetMeter_ID)"+
		                    " WHERE met.A_ASSET_ID=? AND met.MP_Meter_ID=? AND mlog.DATETRX=?",params ).floatValue();
		        	
		        	float days=Math.abs(rs.getTimestamp("LastDay").getTime()-rs.getTimestamp("FIRSTDAY").getTime());
		        	prom=(lastM-firstM) / (days/(60*60*24*1000));
		        	
		        	DB.executeUpdateEx("UPDATE MP_MAINTAIN SET PROMUSE=? WHERE MP_MAINTAIN_ID=?",
		        		new Object[]{prom, rs.getInt("MP_MAINTAIN_ID")}, get_TrxName());	
		        
		            int cont=0;
		            cumple=0;
		            Calendar dateExe=Calendar.getInstance();
		            dateExe.setTime(rs.getTimestamp("LastDay"));
		            //FROM HERE TO SEE IF THE NEXT DAY (7 * PREIODICAL)
		            log.info("Meter Loop");
		            do{       
		            
		                if((lastM >= (rs.getFloat("NEXTMP")-rs.getFloat("RANGE")) && lastM<= (rs.getFloat("NEXTMP")+rs.getFloat("RANGE")) )
		                		|| (lastM>rs.getFloat("NEXTMP")) ){
		                
		                	cumple=1;
		                	dateExe.add(Calendar.DATE,cont);
		
		                }
		                	else{
		                		lastM=lastM + prom;
		                	cont++;
		                	}
		                
		            } while( cumple==0 && cont!=(10*periodNo));
		            Timestamp currentDate=new Timestamp(dateExe.getTimeInMillis());
		            if(cumple==1 || lastM>rs.getFloat("NEXTMP")){
			            int ciclo=0,period=1;
			            Calendar datefrom = Calendar.getInstance();
						Calendar dateto = Calendar.getInstance();
			            while(period<=periodNo){
							
			            	 int diaA=0, diaB=7;
							 datefrom.add(Calendar.DATE, diaA*period);
							 dateto.add(Calendar.DATE, diaA*diaB);
							 
							 
							if(currentDate.compareTo(datefrom.getTime())>=0 &&   currentDate.compareTo(dateto.getTime())<=0)
					            ciclo=period;
						 period++;
						}
			            log.info("Insertmeter");
			            /*StringBuffer insert=new StringBuffer();
			            
			            	insert.append("INSERT INTO MP_Prognosis");
			            	insert.append("VALUES ("+p_PInstance_ID+","+rs.getInt("AD_CLIENT_ID")+","+rs.getInt("AD_ORG_ID")+",'Y',"+stringDate +",100,"+stringDate +",100,");
			            	insert.append(rs.getInt("A_ASSET_ID")+","+rs.getInt("MP_MAINTAIN_ID")+",'"+(ciclo==0?"by Meter behind schedule":"by Meter"));
			            	insert.append(rs.getString("MESURETYPE")+":'||ROUND("+lastM+",2),'"+rs.getString("PROGRAMMINGTYPE")+"',"+ciclo+",'"+currentDate+"','N','N')");
			            DB.executeUpdate(insert.toString(), get_TrxName());*/
			            
			            MMPPrognosis mp=new MMPPrognosis(getCtx(), 0, get_TrxName());
			            mp.setA_Asset_ID(rs.getInt("A_ASSET_ID"));
			            mp.setAD_Org_ID(rs.getInt("AD_ORG_ID"));
			            mp.setAD_PInstance_ID(p_PInstance_ID);
			            mp.setciclo(ciclo);
			            mp.setDateTrx(currentDate);
			            mp.setDescription((ciclo==0?"By Meter behind schedule ":"By Meter on schedule")+rs.getString("name")+":"+lastM);
			            mp.setMP_Maintain_ID(rs.getInt("MP_MAINTAIN_ID"));
			            mp.setProgrammingType(rs.getString("PROGRAMMINGTYPE"));
			            mp.setselected(false);	           
			            mp.saveEx();
			            counter++;
		            }
		             
		        }
			}
			
//			commitEx();
			
			rs.close();
			pstmt.close();
			pstmt = null;
		}
		catch (Exception e)
		{
			log.log(Level.SEVERE, e.getMessage(), e);
		}
		
		log.info("Correction to nesting");
		
		
		String sql="select * from MP_Prognosis where AD_PINSTANCE_ID="+p_PInstance_ID+" and PROGRAMMINGTYPE='M'";
		pstmt = null;
		try
		{
			pstmt = DB.prepareStatement(byCalendar.toString(), get_TrxName());
			ResultSet rs = pstmt.executeQuery();
			while (rs.next())
			{
				int maintainParentId = rs.getInt("MP_MAINTAIN_ID");
				int assetId = rs.getInt("A_ASSET_ID");
				int ciclo = rs.getInt("ciclo");

				int MP_ID = DB.getSQLValue(get_TrxName(),
					"SELECT P.MP_MAINTAIN_ID FROM MP_Prognosis P " +
					"INNER JOIN MP_MAINTAIN M ON (P.MP_MAINTAIN_ID=M.MP_MAINTAIN_ID) " +
					"WHERE M.MP_MAINTAINPARENT_ID=? AND P.A_ASSET_ID=? AND P.AD_PINSTANCE_ID=?",
					maintainParentId, assetId, p_PInstance_ID);

				while(MP_ID>0){
					DB.executeUpdateEx("UPDATE MP_Prognosis SET SELECTED='Y' " +
						"WHERE A_ASSET_ID=? AND MP_MAINTAIN_ID=? AND AD_PINSTANCE_ID=? AND CICLO=?",
						new Object[]{assetId, MP_ID, p_PInstance_ID, ciclo}, get_TrxName());

					MP_ID = DB.getSQLValue(get_TrxName(),
						"SELECT P.MP_MAINTAIN_ID FROM MP_Prognosis P " +
						"INNER JOIN MP_MAINTAIN M ON (P.MP_MAINTAIN_ID=M.MP_MAINTAIN_ID) " +
						"WHERE M.MP_MAINTAINPARENT_ID=? AND P.A_ASSET_ID=? AND P.AD_PINSTANCE_ID=?",
						MP_ID, assetId, p_PInstance_ID);
				}
			}
			
			rs.close();
			pstmt.close();
			pstmt = null;
			
//			commitEx();
		}
		catch (Exception e)
		{
			log.log(Level.SEVERE, e.getMessage(), e);
		}
			
		return("Number of records generated: "+counter);
				
	   
	}	//	doIt


	
}	//	ShipInOut
