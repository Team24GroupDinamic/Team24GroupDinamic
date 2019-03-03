package com.example.hackerman.check_in;

class JsonClasses {

    class SurnameNumber {
        SurnameNumber(String surname, String registrationNumber, String aircompanyId) {
            this.surname = surname;
            this.registrationNumber = registrationNumber;
            this.aircompanyId = aircompanyId;
        }

        private String surname;

        private String registrationNumber;

        private String aircompanyId;

        String getSurname() {
            return surname;
        }

        String getRegistrationNumber() {
            return registrationNumber;
        }

        String getAircompanyId() {
            return aircompanyId;
        }
    }

    class AirCompanies {
        private Aircompany[] aircompanies;

        Aircompany[] getAircompanies() {
            return aircompanies;
        }

        public void setAircompanies(Aircompany[] aircompanies) {
            this.aircompanies = aircompanies;
        }
    }

    class Aircompany {

        private String name;

        private String id;

        private String logoURL;

        String getName() {
            return name;
        }

        void setName(String name) {
            this.name = name;
        }

        String getId() {
            return id;
        }

        void setId(String id) {
            this.id = id;
        }

        String getLogoURL() {
            return logoURL;
        }

        void setLogoURL(String logoURL) {
            this.logoURL = logoURL;
        }
    }

    class Error {

        private String error;

        String getError() {
            return error;
        }

        void setError(String errorText) {
            this.error = errorText;
        }
    }
}
