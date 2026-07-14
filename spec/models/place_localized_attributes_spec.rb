# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Place, type: :model do
  describe 'localized attributes with fallback to defaults' do
    let(:map) { create(:map, primary_language: 'de') }
    let(:layer) { create(:layer, map: map) }
    let(:place) do
      create(:place,
             layer: layer,
             title: 'Deutscher Titel',
             subtitle: 'Deutscher Untertitel',
             teaser: 'Deutscher Teaser',
             text: 'Deutscher Text',
             sources: 'Deutsche Quellen')
    end

    describe '#localized_title' do
      context 'when no translation exists' do
        it 'returns the default title field' do
          expect(place.localized_title).to eq('Deutscher Titel')
        end

        it 'returns default title in any locale without translation' do
          Mobility.with_locale(:en) do
            expect(place.localized_title).to eq('Deutscher Titel')
          end

          Mobility.with_locale(:fr) do
            expect(place.localized_title).to eq('Deutscher Titel')
          end
        end
      end

      context 'when translation exists in locale' do
        it 'returns the translated title for that locale' do
          Mobility.with_locale(:en) do
            place.update(localized_title: 'English Title')
          end

          Mobility.with_locale(:en) do
            expect(place.localized_title).to eq('English Title')
          end

          # Default should remain unchanged
          expect(place.title).to eq('Deutscher Titel')
        end

        it 'maintains translation consistency after multiple edits' do
          # First edit in English
          Mobility.with_locale(:en) do
            place.update(localized_title: 'English Title v1')
          end

          # Second edit in English
          Mobility.with_locale(:en) do
            place.update(localized_title: 'English Title v2')
          end

          # Verify the latest edit is preserved
          Mobility.with_locale(:en) do
            expect(place.localized_title).to eq('English Title v2')
          end
        end
      end

      context 'when translation is blank' do
        it 'falls back to default title' do
          Mobility.with_locale(:en) do
            place.update(localized_title: '')
          end

          Mobility.with_locale(:en) do
            expect(place.localized_title).to eq('Deutscher Titel')
          end
        end

        it 'falls back to default title when nil' do
          Mobility.with_locale(:en) do
            place.update(localized_title: nil)
          end

          Mobility.with_locale(:en) do
            expect(place.localized_title).to eq('Deutscher Titel')
          end
        end
      end

      context 'with primary language de' do
        it 'returns default title in primary language' do
          Mobility.with_locale(:de) do
            expect(place.localized_title).to eq('Deutscher Titel')
          end
        end

        it 'allows editing primary language independently' do
          Mobility.with_locale(:de) do
            place.update(localized_title: 'Aktualisierter Deutscher Titel')
          end

          Mobility.with_locale(:de) do
            expect(place.localized_title).to eq('Aktualisierter Deutscher Titel')
          end

          # Default field might still be old value
          expect(place.title).to eq('Deutscher Titel')
        end
      end
    end

    describe '#localized_subtitle' do
      context 'when no translation exists' do
        it 'returns the default subtitle field' do
          expect(place.localized_subtitle).to eq('Deutscher Untertitel')
        end
      end

      context 'when translation exists' do
        it 'returns translated subtitle in locale' do
          Mobility.with_locale(:en) do
            place.update(localized_subtitle: 'English Subtitle')
          end

          Mobility.with_locale(:en) do
            expect(place.localized_subtitle).to eq('English Subtitle')
          end
        end
      end

      context 'when translation is blank' do
        it 'falls back to default subtitle' do
          Mobility.with_locale(:en) do
            place.update(localized_subtitle: '')
          end

          Mobility.with_locale(:en) do
            expect(place.localized_subtitle).to eq('Deutscher Untertitel')
          end
        end
      end
    end

    describe '#localized_teaser' do
      context 'when no translation exists' do
        it 'returns the default teaser field' do
          expect(place.localized_teaser).to eq('Deutscher Teaser')
        end
      end

      context 'when translation exists' do
        it 'returns translated teaser in locale' do
          Mobility.with_locale(:fr) do
            place.update(localized_teaser: 'French Teaser')
          end

          Mobility.with_locale(:fr) do
            expect(place.localized_teaser).to eq('French Teaser')
          end
        end
      end
    end

    describe '#localized_text' do
      context 'when no translation exists' do
        it 'returns the default text field' do
          expect(place.localized_text).to eq('Deutscher Text')
        end
      end

      context 'when translation exists' do
        it 'returns translated text in locale' do
          Mobility.with_locale(:ru) do
            place.update(localized_text: 'Русский текст')
          end

          Mobility.with_locale(:ru) do
            expect(place.localized_text).to eq('Русский текст')
          end
        end
      end
    end

    describe '#localized_sources' do
      context 'when no translation exists' do
        it 'returns the default sources field' do
          expect(place.localized_sources).to eq('Deutsche Quellen')
        end
      end

      context 'when translation exists' do
        it 'returns translated sources in locale' do
          Mobility.with_locale(:it) do
            place.update(localized_sources: 'Fonti Italiane')
          end

          Mobility.with_locale(:it) do
            expect(place.localized_sources).to eq('Fonti Italiane')
          end
        end
      end
    end

    describe 'multiple locales consistency' do
      it 'maintains independent translations for different locales' do
        # Set up English translation
        Mobility.with_locale(:en) do
          place.update(
            localized_title: 'English Title',
            localized_subtitle: 'English Subtitle'
          )
        end

        # Set up French translation
        Mobility.with_locale(:fr) do
          place.update(
            localized_title: 'Titre Français',
            localized_subtitle: 'Sous-titre Français'
          )
        end

        # Verify English is intact
        Mobility.with_locale(:en) do
          expect(place.localized_title).to eq('English Title')
          expect(place.localized_subtitle).to eq('English Subtitle')
        end

        # Verify French is intact
        Mobility.with_locale(:fr) do
          expect(place.localized_title).to eq('Titre Français')
          expect(place.localized_subtitle).to eq('Sous-titre Français')
        end

        # Verify German defaults are still there
        Mobility.with_locale(:de) do
          expect(place.localized_title).to eq('Deutscher Titel')
          expect(place.localized_subtitle).to eq('Deutscher Untertitel')
        end
      end

      it 'can update one locale without affecting others' do
        # Set up English
        Mobility.with_locale(:en) do
          place.update(localized_title: 'English Title')
        end

        # Set up French
        Mobility.with_locale(:fr) do
          place.update(localized_title: 'Titre Français')
        end

        # Update English
        Mobility.with_locale(:en) do
          place.update(localized_title: 'Updated English Title')
        end

        # French should be unchanged
        Mobility.with_locale(:fr) do
          expect(place.localized_title).to eq('Titre Français')
        end

        # English should be updated
        Mobility.with_locale(:en) do
          expect(place.localized_title).to eq('Updated English Title')
        end
      end
    end
  end
end
