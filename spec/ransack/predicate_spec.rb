require 'spec_helper'

module Ransack
  describe Predicate do

    before do
      @s = Search.new(Person)
    end

    shared_examples 'wildcard escaping' do |method, regexp|
      it 'automatically converts integers to strings' do
        subject.parent_id_cont = 1
        expect { subject.result }.to_not raise_error
      end

      it "escapes '%', '.' and '\\\\' in value" do
        subject.send(:"#{method}=", '%._\\')
        subject.result.to_sql.should match(regexp)
      end
    end

    describe 'eq' do
      it 'generates an equality condition for boolean true' do
        @s.awesome_eq = true
        field = "#{quote_table_name("people")}.#{
          quote_column_name("awesome")}"
        @s.result.to_sql.should match /#{field} = #{
          ActiveRecord::Base.connection.quoted_true}/
      end

      it 'generates an equality condition for boolean false' do
        @s.awesome_eq = false
        field = "#{quote_table_name("people")}.#{quote_column_name("awesome")}"
        @s.result.to_sql.should match /#{field} = #{
          ActiveRecord::Base.connection.quoted_false}/
      end

      it 'does not generate a condition for nil' do
        @s.awesome_eq = nil
        @s.result.to_sql.should_not match /WHERE/
      end
    end

    describe 'present' do
      it 'generates a condition for boolean true' do
        @s.name_present = true
        field = "#{quote_table_name("people")}.#{quote_column_name("name")}"
        @s.result.to_sql.should match /#{field} IS NOT NULL AND #{field} != ''/
      end

      it 'generates a condition for boolean false' do
        @s.name_present = false
        field = "#{quote_table_name("people")}.#{quote_column_name("name")}"
        @s.result.to_sql.should match /#{field} IS NULL OR #{field} = ''/
      end

      it 'does not generate a condition for nil' do
        @s.name_present = nil
        @s.result.to_sql.should_not match /WHERE/
      end
    end

    describe 'blank' do
      it 'generates a condition for boolean true' do
        @s.name_blank = true
        field = "#{quote_table_name("people")}.#{quote_column_name("name")}"
        @s.result.to_sql.should match /#{field} IS NULL OR #{field} = ''/
      end

      it 'generates a condition for boolean false' do
        @s.name_blank = false
        field = "#{quote_table_name("people")}.#{quote_column_name("name")}"
        @s.result.to_sql.should match /#{field} IS NOT NULL AND #{field} != ''/
      end

      it 'does not generate a condition for nil' do
        @s.name_blank = nil
        @s.result.to_sql.should_not match /WHERE/
      end
    end

    describe 'true' do
      it 'generates a condition for boolean true' do
        @s.awesome_true = true
        field = "#{quote_table_name("people")}.#{quote_column_name("awesome")}"
        @s.result.to_sql.should match /#{field} = #{
          ActiveRecord::Base.connection.quoted_true}/
      end

      it 'generates a condition for boolean false' do
        @s.awesome_true = false
        field = "#{quote_table_name("people")}.#{quote_column_name("awesome")}"
        @s.result.to_sql.should match /#{field} != #{
          ActiveRecord::Base.connection.quoted_true}/
      end

      it 'does not generate a condition for nil' do
        @s.awesome_true = nil
        @s.result.to_sql.should_not match /WHERE/
      end
    end

    describe 'not_true' do
      it 'generates a condition for boolean true' do
        @s.awesome_not_true = true
        field = "#{quote_table_name("people")}.#{quote_column_name("awesome")}"
        @s.result.to_sql.should match /#{field} != #{
          ActiveRecord::Base.connection.quoted_true}/
      end

      it 'generates a condition for boolean false' do
        @s.awesome_not_true = false
        field = "#{quote_table_name("people")}.#{quote_column_name("awesome")}"
        @s.result.to_sql.should match /#{field} = #{
          ActiveRecord::Base.connection.quoted_true}/
      end

      it 'does not generate a condition for nil' do
        @s.awesome_not_true = nil
        @s.result.to_sql.should_not match /WHERE/
      end
    end

    describe 'false' do
      it 'generates a condition for boolean true' do
        @s.awesome_false = true
        field = "#{quote_table_name("people")}.#{quote_column_name("awesome")}"
        @s.result.to_sql.should match /#{field} = #{
          ActiveRecord::Base.connection.quoted_false}/
      end

      it 'generates a condition for boolean false' do
        @s.awesome_false = false
        field = "#{quote_table_name("people")}.#{quote_column_name("awesome")}"
        @s.result.to_sql.should match /#{field} != #{
          ActiveRecord::Base.connection.quoted_false}/
      end

      it 'does not generate a condition for nil' do
        @s.awesome_false = nil
        @s.result.to_sql.should_not match /WHERE/
      end
    end

    describe 'not_false' do
      it 'generates a condition for boolean true' do
        @s.awesome_not_false = true
        field = "#{quote_table_name("people")}.#{quote_column_name("awesome")}"
        @s.result.to_sql.should match /#{field} != #{
          ActiveRecord::Base.connection.quoted_false}/
      end

      it 'generates a condition for boolean false' do
        @s.awesome_not_false = false
        field = "#{quote_table_name("people")}.#{quote_column_name("awesome")}"
        @s.result.to_sql.should match /#{field} = #{
          ActiveRecord::Base.connection.quoted_false}/
      end

      it 'does not generate a condition for nil' do
        @s.awesome_not_false = nil
        @s.result.to_sql.should_not match /WHERE/
      end
    end

    describe 'null' do
      it 'generates a condition for boolean true' do
        @s.name_null = true
        field = "#{quote_table_name("people")}.#{quote_column_name("name")}"
        @s.result.to_sql.should match /#{field} IS NULL/
      end

      it 'generates a condition for boolean false' do
        @s.name_null = false
        field = "#{quote_table_name("people")}.#{quote_column_name("name")}"
        @s.result.to_sql.should match /#{field} IS NOT NULL/
      end

      it 'does not generate a condition for nil' do
        @s.name_null = nil
        @s.result.to_sql.should_not match /WHERE/
      end
    end

    describe 'not_null' do
      it 'generates a condition for boolean true' do
        @s.name_not_null = true
        field = "#{quote_table_name("people")}.#{quote_column_name("name")}"
        @s.result.to_sql.should match /#{field} IS NOT NULL/
      end

      it 'generates a condition for boolean false' do
        @s.name_not_null = false
        field = "#{quote_table_name("people")}.#{quote_column_name("name")}"
        @s.result.to_sql.should match /#{field} IS NULL/
      end

      it 'does not generate a condition for nil' do
        @s.name_not_null = nil
        @s.result.to_sql.should_not match /WHERE/
      end
    end

    describe 'cont' do
      it_has_behavior 'wildcard escaping', :name_cont,
        (if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
          /"people"."name" ILIKE '%\\%\\._\\\\%'/
        elsif ActiveRecord::Base.connection.adapter_name == "Mysql2"
          /`people`.`name` LIKE '%\\\\%\\\\._\\\\\\\\%'/
        else
         /"people"."name" LIKE '%%._\\%'/
        end) do
        subject { @s }
      end

      it 'generates a LIKE query with value surrounded by %' do
        @s.name_cont = 'ric'
        field = "#{quote_table_name("people")}.#{quote_column_name("name")}"
        @s.result.to_sql.should match /#{field} I?LIKE '%ric%'/
      end
    end

    describe 'not_cont' do
      it_has_behavior 'wildcard escaping', :name_not_cont,
        (if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
          /"people"."name" NOT ILIKE '%\\%\\._\\\\%'/
        elsif ActiveRecord::Base.connection.adapter_name == "Mysql2"
          /`people`.`name` NOT LIKE '%\\\\%\\\\._\\\\\\\\%'/
        else
         /"people"."name" NOT LIKE '%%._\\%'/
        end) do
        subject { @s }
      end

      it 'generates a NOT LIKE query with value surrounded by %' do
        @s.name_not_cont = 'ric'
        field = "#{quote_table_name("people")}.#{quote_column_name("name")}"
        @s.result.to_sql.should match /#{field} NOT I?LIKE '%ric%'/
      end
    end
  end
end
