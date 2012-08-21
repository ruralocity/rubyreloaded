# A simple DSL to create what we call a "walkthrough" at my work.
# A walkthrough is a simple data instrument designed to capture what's
# happening in a classroom over a three-minute block of time. In the real
# world this would persist a walkthrough via ActiveRecord; here I'm just
# rendering some psuedo-HTML.
#
# I've historically created a YML outline of a given walkthrough and then
# processed and stored it using a parser class. While the YML itself is
# relatively clean, the parser is not an easy read.
#
# A walkthrough consists of one or more sections, each made up of one or
# more item groups. An item group has one or more items. An item may be
# one of three types: A checkbox (boolean), a radio (select one from a group),
# or a short answer text. The DSL would thus look like
#
#     wt = Walkthrough.new
#     output = wt.walkthrough "Sample Walkthrough" do
#       section "Section A" do
#         item_group "Item Group A" do
#           item "First Item", :checkbox
#           item "Second Item", :radio do
#             value "First Value"
#             value "Second Value"
#           end
#         end
#         item_group "Item Group B" do
#           item "Third Item", :text
#         end
#       end
#       
#       section "Section B" do
#         item_group "Item Group C" do
#           item "Fourth Item", :checkbox
#         end
#       end
#     end
#
# I'm not sure if the walkthrough, section, and item_group methods are similar
# enough to refactor or spruce up with metaprogramming; I also imagine there's
# a better way to handle the format case in the item method.

class Walkthrough
  def initialize
    @out = ''
  end
  
  def walkthrough(name, &block)
    div(name, :walkthrough, :h1, &block)
  end

  def section(name, &block)
    div(name, :section, :h2, &block)
  end
  
  def item_group(name, &block)
    div(name, :item_group, :h3, &block)
  end
  
  def item(name, format, &block)
    @out << "<div>"
    case format
    when :checkbox
      @out << "[ ] #{name}"
    when :text
      @out << "___ #{name}"
    when :radio
      @out << "#{name} "
      if block_given?
        instance_eval &block
        @out.chop!
      end
    end
    @out << '</div>'
  end
  
  private
  
  def value(name)
    @out << "( ) #{name} "
  end

  def div(name, type, tag, &block)
    @out << "<div class='#{type}'><#{tag}>#{name}</#{tag}>"
    instance_eval &block if block_given?
    @out << "</div>"
  end
end

#
# And here are the tests:
#

if __FILE__ == $0

  require 'minitest/autorun'

  class WalkthroughSpec < MiniTest::Spec
    it "creates a walkthrough structure" do
      wt = Walkthrough.new
      output = wt.walkthrough 'Classroom Walkthrough'
      output.must_equal "<div class='walkthrough'><h1>Classroom Walkthrough</h1></div>"
    end

    it "creates a walkthrough section" do
      wt = Walkthrough.new
      output = wt.section 'Routines'
      output.must_equal "<div class='section'><h2>Routines</h2></div>"
    end
  
    it "nests item groups within sections" do
      wt = Walkthrough.new
      output = wt.section 'Routines' do
        item_group 'Observed'
      end
    
      output.must_equal "<div class='section'><h2>Routines</h2><div class='item_group'><h3>Observed</h3></div></div>"
    end

    it "creates an item group" do
      wt = Walkthrough.new
      output = wt.item_group 'Programs'
      output.must_equal "<div class='item_group'><h3>Programs</h3></div>"
    end

    it "nests items within item groups" do
      wt = Walkthrough.new
      output = wt.item_group 'Observed' do
        item 'Unit Organizer', :checkbox
        item 'Lesson Organizer', :checkbox
      end
    
      output.must_equal "<div class='item_group'><h3>Observed</h3><div>[ ] Unit Organizer</div><div>[ ] Lesson Organizer</div></div>"
    end

    it "creates a checkbox item" do
      wt = Walkthrough.new
      output = wt.item 'Special Education', :checkbox
      output.must_equal "<div>[ ] Special Education</div>"
    end
  
    it "creates a radio group item" do
      wt = Walkthrough.new
      output = wt.item 'Subject', :radio do
        value 'Math'
        value 'Science'
        value 'Social Studies'
      end
      output.must_equal "<div>Subject ( ) Math ( ) Science ( ) Social Studies</div>"
    end
  
    it "creates a short answer item" do
      wt = Walkthrough.new
      output = wt.item 'Students', :text
      output.must_equal "<div>___ Students</div>"
    end
  
    it "creates a simple walkthrough" do
      wt = Walkthrough.new
      output = wt.walkthrough "Sample Walkthrough" do
        section "Section A" do
          item_group "Item Group A" do
            item "First Item", :checkbox
            item "Second Item", :radio do
              value "First Value"
              value "Second Value"
            end
          end
          item_group "Item Group B" do
            item "Third Item", :text
          end
        end
      
        section "Section B" do
          item_group "Item Group C" do
            item "Fourth Item", :checkbox
          end
        end
      end
    
      output.must_equal "<div class='walkthrough'><h1>Sample Walkthrough</h1><div class='section'><h2>Section A</h2><div class='item_group'><h3>Item Group A</h3><div>[ ] First Item</div><div>Second Item ( ) First Value ( ) Second Value</div></div><div class='item_group'><h3>Item Group B</h3><div>___ Third Item</div></div></div><div class='section'><h2>Section B</h2><div class='item_group'><h3>Item Group C</h3><div>[ ] Fourth Item</div></div></div></div>"
    end
  end
end