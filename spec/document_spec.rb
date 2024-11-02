# frozen_string_literal: true

require 'rspec/matchers'
require 'equivalent-xml'

# rubocop:disable Metrics/BlockLength, Layout/LineLength
describe BodyParty::Document do
  describe 'generate_body' do
    context 'one level nodes' do
    end
    context 'two level nodes' do
      it 'should return expected XML without attributes nodes' do
        xpaths = [
          'person/name?=John Doe',
          'person/age?=30',
          'person/city?=New York',
          'person/occupation?=Engineer',
          'person/email?=johndoe@example.com',
          'person/isActive?=true',
          'company/name?=Tech Solutions Inc.',
          'company/industry?=Software',
          'company/location?=San Francisco',
          'company/employees?=500'
        ]
        generated_xml = described_class.generate(xpaths: xpaths)

        example = <<-XML
          <?xml version="1.0" encoding="UTF-8"?>
          <person>
            <name>John Doe</name>
            <age>30</age>
            <city>New York</city>
            <occupation>Engineer</occupation>
            <email>johndoe@example.com</email>
            <isActive>true</isActive>
          </person>
          <company>
            <name>Tech Solutions Inc.</name>
            <industry>Software</industry>
            <location>San Francisco</location>
            <employees>500</employees>
          </company>
        XML

        expect(generated_xml).to be_equivalent_to(example)
      end

      it 'should return expected XML with one attribute' do
        xpaths = [
          'person[@id=1]/name?=John Doe',
          'person[@id=1]/age?=30',
          'person[@id=1]/city?=New York',
          'person[@id=1]/occupation?=Engineer',
          'person[@id=1]/email?=johndoe@example.com',
          'person[@id=1]/isActive?=true',
          'company/name?=Tech Solutions Inc.',
          'company/industry?=Software',
          'company/location?=San Francisco',
          'company/employees?=500',
          'company[@id=10]/name?=Tech Solutions Inc 2',
          'company[@id=10]/industry?=Sass',
          'company[@id=10]/location?=New york',
          'company[@id=10]/employees?=1000'
        ]
        generated_xml = described_class.generate(xpaths: xpaths)

        example = <<-XML
          <?xml version="1.0" encoding="UTF-8"?>
          <person id="1">
            <name>John Doe</name>
            <age>30</age>
            <city>New York</city>
            <occupation>Engineer</occupation>
            <email>johndoe@example.com</email>
            <isActive>true</isActive>
          </person>
          <company>
            <name>Tech Solutions Inc.</name>
            <industry>Software</industry>
            <location>San Francisco</location>
            <employees>500</employees>
          </company>
          <company id="10">
            <name>Tech Solutions Inc 2</name>
            <industry>Sass</industry>
            <location>New york</location>
            <employees>1000</employees>
          </company>
        XML

        expect(generated_xml).to be_equivalent_to(example)
      end

      it 'should return expected XML with more than one attribute' do
        xpaths = [
          'person[@id=1 @db_id=847503]/name?=John Doe',
          'person[@id=1 @db_id=847503]/age?=30',
          'person[@id=1 @db_id=847503]/city?=New York',
          'person[@id=1 @db_id=847503]/occupation?=Engineer',
          'person[@id=1 @db_id=847503]/email?=johndoe@example.com',
          'person[@id=1 @db_id=847503]/isActive?=true',
          'company/name?=Tech Solutions Inc.',
          'company/industry?=Software',
          'company/location?=San Francisco',
          'company/employees?=500',
          'company[@id=10 @debt=false @running=true]/name?=Tech Solutions Inc 2',
          'company[@id=10 @debt=false @running=true]/industry?=Sass',
          'company[@id=10 @debt=false @running=true]/location?=New york',
          'company[@id=10 @debt=false @running=true]/employees?=1000'
        ]
        generated_xml = described_class.generate(xpaths: xpaths)

        example = <<-XML
          <?xml version="1.0" encoding="UTF-8"?>
          <person id="1" db_id="847503">
            <name>John Doe</name>
            <age>30</age>
            <city>New York</city>
            <occupation>Engineer</occupation>
            <email>johndoe@example.com</email>
            <isActive>true</isActive>
          </person>
          <company>
            <name>Tech Solutions Inc.</name>
            <industry>Software</industry>
            <location>San Francisco</location>
            <employees>500</employees>
          </company>
          <company id="10" debt="false" running="true">
            <name>Tech Solutions Inc 2</name>
            <industry>Sass</industry>
            <location>New york</location>
            <employees>1000</employees>
          </company>
        XML

        expect(generated_xml).to be_equivalent_to(example)
      end
    end
    context 'more than three levels nodes' do
      it 'should return expected XML with one attribute' do
        xpaths =
          [
            'university/departments/department[@id=1]/name?=Computer Science',
            'university/departments/department[@id=1]/courses/course[@id=CS101]/title?=Introduction to Programming',
            'university/departments/department[@id=1]/courses/course[@id=CS101]/credits?=4',
            'university/departments/department[@id=1]/courses/course[@id=CS101]/professor/name?=Dr. Alice Smith',
            'university/departments/department[@id=1]/courses/course[@id=CS101]/professor/office?=Building A, Room 101',
            'university/departments/department[@id=1]/courses/course[@id=CS101]/schedule/day?=Monday',
            'university/departments/department[@id=1]/courses/course[@id=CS101]/schedule/time?=09:00 - 11:00',
            'university/departments/department[@id=1]/courses/course[@id=CS101]/students/student[@id=S001]/name?=John Doe',
            'university/departments/department[@id=1]/courses/course[@id=CS101]/students/student[@id=S001]/grade?=A',
            'university/departments/department[@id=1]/courses/course[@id=CS101]/students/student[@id=S002]/name?=Jane Roe',
            'university/departments/department[@id=1]/courses/course[@id=CS101]/students/student[@id=S002]/grade?=B+',
            'university/departments/department[@id=1]/courses/course[@id=CS102]/title?=Data Structures',
            'university/departments/department[@id=1]/courses/course[@id=CS102]/credits?=3',
            'university/departments/department[@id=1]/courses/course[@id=CS102]/professor/name?=Dr. Bob Williams',
            'university/departments/department[@id=1]/courses/course[@id=CS102]/professor/office?=Building A, Room 102',
            'university/departments/department[@id=1]/courses/course[@id=CS102]/schedule/day?=Wednesday',
            'university/departments/department[@id=1]/courses/course[@id=CS102]/schedule/time?=13:00 - 15:00',
            'university/departments/department[@id=1]/courses/course[@id=CS102]/students/student[@id=S003]/name?=Alex Brown',
            'university/departments/department[@id=1]/courses/course[@id=CS102]/students/student[@id=S003]/grade?=A-',
            'university/departments/department[@id=2]/name?=Mathematics',
            'university/departments/department[@id=2]/courses/course[@id=MATH101]/title?=Calculus I',
            'university/departments/department[@id=2]/courses/course[@id=MATH101]/credits?=4',
            'university/departments/department[@id=2]/courses/course[@id=MATH101]/professor/name?=Dr. Carol Johnson',
            'university/departments/department[@id=2]/courses/course[@id=MATH101]/professor/office?=Building B, Room 201',
            'university/departments/department[@id=2]/courses/course[@id=MATH101]/schedule/day?=Tuesday',
            'university/departments/department[@id=2]/courses/course[@id=MATH101]/schedule/time?=10:00 - 12:00',
            'university/departments/department[@id=2]/courses/course[@id=MATH101]/students/student[@id=S004]/name?=Emily White',
            'university/departments/department[@id=2]/courses/course[@id=MATH101]/students/student[@id=S004]/grade?=B',
            'university/departments/department[@id=2]/courses/course[@id=MATH101]/students/student[@id=S005]/name?=Chris Green',
            'university/departments/department[@id=2]/courses/course[@id=MATH101]/students/student[@id=S005]/grade?=A',
            'university/students/student[@id=S001]/name?=John Doe',
            'university/students/student[@id=S001]/major?=Computer Science',
            'university/students/student[@id=S001]/year?=2',
            'university/students/student[@id=S002]/name?=Jane Roe',
            'university/students/student[@id=S002]/major?=Computer Science',
            'university/students/student[@id=S002]/year?=2',
            'university/students/student[@id=S003]/name?=Alex Brown',
            'university/students/student[@id=S003]/major?=Computer Science',
            'university/students/student[@id=S003]/year?=3',
            'university/students/student[@id=S004]/name?=Emily White',
            'university/students/student[@id=S004]/major?=Mathematics',
            'university/students/student[@id=S004]/year?=1',
            'university/students/student[@id=S005]/name?=Chris Green',
            'university/students/student[@id=S005]/major?=Mathematics',
            'university/students/student[@id=S005]/year?=1'
          ]
        generated_xml = described_class.generate(xpaths: xpaths)

        example = <<-XML
          <?xml version="1.0" encoding="UTF-8"?>
          <university>
            <departments>
              <department id="1">
                <name>Computer Science</name>
                <courses>
                  <course id="CS101">
                    <title>Introduction to Programming</title>
                    <credits>4</credits>
                    <professor>
                      <name>Dr. Alice Smith</name>
                      <office>Building A, Room 101</office>
                    </professor>
                    <schedule>
                      <day>Monday</day>
                      <time>09:00 - 11:00</time>
                    </schedule>
                    <students>
                      <student id="S001">
                        <name>John Doe</name>
                        <grade>A</grade>
                      </student>
                      <student id="S002">
                        <name>Jane Roe</name>
                        <grade>B+</grade>
                      </student>
                    </students>
                  </course>
                  <course id="CS102">
                    <title>Data Structures</title>
                    <credits>3</credits>
                    <professor>
                      <name>Dr. Bob Williams</name>
                      <office>Building A, Room 102</office>
                    </professor>
                    <schedule>
                      <day>Wednesday</day>
                      <time>13:00 - 15:00</time>
                    </schedule>
                    <students>
                      <student id="S003">
                        <name>Alex Brown</name>
                        <grade>A-</grade>
                      </student>
                    </students>
                  </course>
                </courses>
              </department>
              <department id="2">
                <name>Mathematics</name>
                <courses>
                  <course id="MATH101">
                    <title>Calculus I</title>
                    <credits>4</credits>
                    <professor>
                      <name>Dr. Carol Johnson</name>
                      <office>Building B, Room 201</office>
                    </professor>
                    <schedule>
                      <day>Tuesday</day>
                      <time>10:00 - 12:00</time>
                    </schedule>
                    <students>
                      <student id="S004">
                        <name>Emily White</name>
                        <grade>B</grade>
                      </student>
                      <student id="S005">
                        <name>Chris Green</name>
                        <grade>A</grade>
                      </student>
                    </students>
                  </course>
                </courses>
              </department>
            </departments>
            <students>
              <student id="S001">
                <name>John Doe</name>
                <major>Computer Science</major>
                <year>2</year>
              </student>
              <student id="S002">
                <name>Jane Roe</name>
                <major>Computer Science</major>
                <year>2</year>
              </student>
              <student id="S003">
                <name>Alex Brown</name>
                <major>Computer Science</major>
                <year>3</year>
              </student>
              <student id="S004">
                <name>Emily White</name>
                <major>Mathematics</major>
                <year>1</year>
              </student>
              <student id="S005">
                <name>Chris Green</name>
                <major>Mathematics</major>
                <year>1</year>
              </student>
            </students>
          </university>

        XML
        expect(generated_xml).to be_equivalent_to(example)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength, Layout/LineLength
