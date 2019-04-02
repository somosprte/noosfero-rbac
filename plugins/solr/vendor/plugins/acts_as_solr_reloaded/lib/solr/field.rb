# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class Solr::Field
  VALID_PARAMS = [:boost]
  attr_accessor :name
  attr_accessor :value
  attr_accessor :boost

  # Accepts an optional <tt>:boost</tt> parameter, used to boost the relevance of a particular field.
  def initialize(params)
    boost = params[:boost]
    @name = params[:name].to_s
    @value = params[:value]
    # Convert any Time values into UTC/XML schema format (which Solr requires).
    @value = @value.respond_to?(:utc) ? @value.utc.xmlschema : @value
  end

  def value_to_jsonhash
    @boost.nil? ? @value : {'boost' => @boost, 'value' => @value}
  end 

  def boost=(value)
    @boost = value == 1.0 ? nil : value
  end

  def to_xml
    e = Solr::XML::Element.new 'field'
    e.attributes['name'] = @name
    e.attributes['boost'] = @boost.to_s if @boost
    e.text = @value.to_str
    return e
  end

end
