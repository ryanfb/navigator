package info.papyri.dispatch.atom;

import java.util.ArrayList;
import java.util.Date;
import org.apache.solr.common.SolrDocument;


/**
 *
 * @author thill
 */
public class EmendationRecord implements Comparable {
    
    private String id;
    private String title;
    private String summary;
    private String contributorURI;
    private String contributorName;
    private SearchType searchType;
    private ArrayList<Date> emendationDates;
    private ArrayList<String> emendationTypes;
    private ArrayList<Date> relevantEmendationDates;
      
    public EmendationRecord(SolrDocument doc, SearchType st){
        
        id = (String) doc.getFieldValue(SolrField.id.name());
        title = getTitle(id, doc);
        emendationDates = (ArrayList<Date>) doc.getFieldValue(SolrField.edit_date.name());
        emendationTypes = (ArrayList<String>) doc.getFieldValue(SolrField.edit_type.name());
        relevantEmendationDates = filterDatesBySearchType(emendationDates, emendationTypes, searchType);
        summary = getSummary(doc);
        contributorURI = (String) doc.getFieldValue(SolrField.edit_agent.name());
        contributorName = (String) getContributorName(contributorURI);
        searchType = st;
        
        
        
    }
    
    final ArrayList<Date> filterDatesBySearchType(ArrayList<Date> editDates, ArrayList<String> searchTypes, SearchType filterType){
        
        if(filterType == SearchType.all) return new ArrayList<Date>(editDates);
        ArrayList<Date> filteredDates = new ArrayList<Date>();
        for(int i = 0; i < editDates.size(); i++){
        
        try{

            Date editDate = editDates.get(i);
            SearchType editType = SearchType.valueOf(searchTypes.get(i));
            if(editType == filterType){
                
                filteredDates.add(editDate);
                
            }
        }
        catch(NullPointerException npe){}
        catch(IllegalArgumentException iae){}   
        
        }
        
        return filteredDates;
        
    }
    
    /**
     * Assembles the relevant <code>SolrField</code> values into a <code>String</code> 
     * to be used as the value of an atom:title element.
     * 
     * If the passed <code>SolrDocument</code> represents an error condition, the title will
     * be 'Error'. If it represents no results having been returned, the title will be 
     * 'No results found'.
     * 
     * @param id
     * @param doc
     * @return 
     */
    
    final String getTitle(String id, SolrDocument doc){
        
        String localTitle = "";
        String series = "";
        String volume = "";
        String item = "";
        
        if(id.contains("/ddbdp/")){
            
            series = doc.getFieldValue(TitleField.ddbdp_series.name()) == null ? "" : (String) doc.getFieldValue(TitleField.ddbdp_series.name());
            volume = doc.getFieldValue(TitleField.ddbdp_volume.name()) == null ? "" : (String) doc.getFieldValue(TitleField.ddbdp_volume.name());
            item = doc.getFieldValue(TitleField.ddbdp_full_identifier.name()) == null ? "" : (String) doc.getFieldValue(TitleField.ddbdp_full_identifier.name());
            
        }
        else if(id.contains("/hgv/")){
            
            series = doc.getFieldValue(TitleField.hgv_series.name()) == null ? "" : (String) doc.getFieldValue(TitleField.hgv_series.name());
            volume = doc.getFieldValue(TitleField.hgv_volume.name()) == null ? "" : (String) doc.getFieldValue(TitleField.hgv_volume.name());
            item = doc.getFieldValue(TitleField.hgv_full_identifier.name()) == null ? "" : (String) doc.getFieldValue(TitleField.hgv_full_identifier.name());            
            
        }
        else{
            
            series = doc.getFieldValue(TitleField.apis_series.name()) == null ? "" : (String) doc.getFieldValue(TitleField.apis_series.name());
            item = doc.getFieldValue(TitleField.apis_full_identifier.name()) == null ? "" : (String) doc.getFieldValue(TitleField.apis_full_identifier.name());               
            
        }
        
        if(volume.equals("0")) volume = "";
        if(!series.equals("") && (!volume.equals("") || !item.equals(""))) series += " ";
        if(!volume.equals("") && (!item.equals("") || !item.equals(""))) volume += " ";
        localTitle = series + volume + item;
        if(id.equals(AtomFeedServlet.ERROR_ID)) localTitle = "Error";
        if(id.equals(AtomFeedServlet.NONEFOUND_ID)) localTitle = "No reults found";
        if(localTitle.equals("")) localTitle = id;
        return localTitle;
        
    }
    
    /*
     * Assembles <code>SolrField</code> values to populate an atom:summary element
     * 
     * @param doc
     * @return 
     */
    
    // TODO: Are these actually the values desired?
    
    final String getSummary(SolrDocument doc){
        
       if((AtomFeedServlet.ERROR_ID).equals(doc.getFieldValue(SolrField.id.name())) || (AtomFeedServlet.NONEFOUND_ID).equals(doc.getFieldValue(SolrField.id.name()))){
                
           String msg = doc.getFieldValue(SolrField.metadata.name()) == null ? "Unspecified error" : (String) doc.getFieldValue(SolrField.metadata.name());
           return msg;
                
       }
               
        String localSummary = "";
        
        if(doc.getFieldValue(SolrField.title.name()) != null && !doc.getFieldValue(SolrField.title.name()).equals("")){
            
            localSummary += "Title: " + doc.getFieldValue(SolrField.title.name());
            
        }
        
        if(doc.getFieldValue(SolrField.display_place.name()) != null && !doc.getFieldValue(SolrField.display_place.name()).equals("")){
            
            if(localSummary.length() != 0) localSummary += ", ";
            localSummary += "Provenance: " + (String) doc.getFieldValue(SolrField.display_place.name());
            
        }
        if(doc.getFieldValue(SolrField.display_date.name()) != null && !doc.getFieldValue(SolrField.display_date.name()).equals("")){
            
            if(localSummary.length() != 0) localSummary += ", ";
            localSummary += "Date: " + (String) doc.getFieldValue(SolrField.display_date.name());
        }
       
        return localSummary;
        
    }
    
    final String getContributorName(String contributorURI){
          
        if(contributorURI != null){

            contributorURI = contributorURI.replaceAll("\\s", "");
            String[] contributorBits = contributorURI.split("/");
            String cName = contributorBits.length > 0 ? contributorBits[contributorBits.length - 1] : "Papyri.info";
            return cName;

        }
        
        return "";
               
    }
    
    String getID(){ return id; }
    String getTitle() { return title; }
    String getSummary(){ return summary; }
    String getContributorURI(){ return contributorURI; }
    String getContributorName(){ return contributorName; }
    Date getLastEmendationDate(){ return relevantEmendationDates.get(relevantEmendationDates.size() - 1); }
    Date getPublicationDate(){ return emendationDates.get(0); }

    @Override
    public int compareTo(Object o) {
        
        EmendationRecord er2 = (EmendationRecord) o;
        Date thisDate = this.getLastEmendationDate();
        Date thatDate = ((EmendationRecord) o).getLastEmendationDate();
        
        if(thisDate.after(thatDate))  return  1;
        if(thisDate.before(thatDate)) return -1;
        return 0; 
        
    }
    
    
    
}