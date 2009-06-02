package info.papyri.tests;

import info.papyri.epiduke.lucene.analysis.LinePositionTokenStream;
import info.papyri.epiduke.sax.TEIHandler;

import java.io.IOException;

import java.util.Iterator;

import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.Term;
import org.apache.lucene.search.Hits;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.spans.SpanNearQuery;
import org.apache.lucene.search.spans.SpanQuery;
import org.apache.lucene.search.spans.SpanTermQuery;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.RAMDirectory;
import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

import junit.framework.TestCase;

public class PrecombinedGreekLineSpanTest extends TestCase {
/**
 * These test cases are for indexing and matching of precombined Greek Unicode (UTF-8)
 */
	private IndexSearcher iSearch;
	private static final String LINE_SPAN_TERM = "lines";
	private static final String WORD_SPAN_TERM = "words";
	
	protected void setUp() throws Exception {
		super.setUp();
		TEIHandler main = new TEIHandler();
		main.addLineBreakTag("lb");
		main.addLineBreakTag("div0");
		main.addTextPattern("TEI.2/div0");
		XMLReader digest = XMLReaderFactory.createXMLReader();
		digest.setContentHandler(main);
		digest.parse(new InputSource(EnglishLineSpanTest.class.getResourceAsStream("/xml/precombined.xml")));

		Directory inmem = new RAMDirectory();
		StandardAnalyzer sa = new StandardAnalyzer();
		IndexWriter iWrite = new IndexWriter(inmem,sa);
		Document doc = new Document();
		Iterator<String> lines = main.getLines();
		doc.add(new Field(LINE_SPAN_TERM,new LinePositionTokenStream(lines,sa),Field.TermVector.YES));
		doc.add(new Field(WORD_SPAN_TERM,main.getText(),Field.Store.YES,Field.Index.TOKENIZED));

		iWrite.addDocument(doc);
		iWrite.optimize();
		IndexReader iRead = IndexReader.open(inmem);
		iSearch = new IndexSearcher(iRead);
	}

	@Override
	protected void tearDown() throws Exception {
		super.tearDown();
	}
	
	public void testLineSpanPositiveOrderAccept() throws IOException {
		throw new UnsupportedOperationException("unimplemented");
	}
	
	public void testLineSpanPositiveOrderReject() throws IOException {
        throw new UnsupportedOperationException("unimplemented");
	}
	
	public void testWordSpanPositiveOrderAccept() throws IOException {
        throw new UnsupportedOperationException("unimplemented");
	}
	
	public void testWordSpanPositiveOrderReject() throws IOException {
        throw new UnsupportedOperationException("unimplemented");
	}
	

}