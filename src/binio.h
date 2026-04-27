
extern void binio_fopen(      int*  unit      ,
                        const char* file      ,
                        const char* action    ,
                        const long long*  recl,
                        const char* endian    );


extern void binio_fclose(const int* unit);


extern void binio_fread_sp1(const int*   unit        ,
                            const int*   n1          ,
                            const long long*   record,
                                  float* input_data  );

extern void binio_fread_dp1(const int*    unit        ,
                            const int*    n1          ,
                            const long long*    record,
                                  double* input_data  );

extern void binio_fread_sp2(const int*   unit        ,
                            const int*   n1          ,
                            const int*   n2          ,
                            const long long*   record,
                                  float* input_data  );

extern void binio_fread_dp2(const int*    unit        ,
                            const int*    n1          ,
                            const int*    n2          ,
                            const long long*    record,
                                  double* input_data  );

extern void binio_fread_sp3(const int*   unit        ,
                            const int*   n1          ,
                            const int*   n2          ,
                            const int*   n3          ,
                            const long long*   record,
                                  float* input_data  );

extern void binio_fread_dp3(const int*    unit        ,
                            const int*    n1          ,
                            const int*    n2          ,
                            const int*    n3          ,
                            const long long*    record,
                                  double* input_data  );

extern void binio_fread_sp4(const int*   unit        ,
                            const int*   n1          ,
                            const int*   n2          ,
                            const int*   n3          ,
                            const int*   n4          ,
                            const long long*   record,
                                  float* input_data  );

extern void binio_fread_dp4(const int*    unit        ,
                            const int*    n1          ,
                            const int*    n2          ,
                            const int*    n3          ,
                            const int*    n4          ,
                            const long long*    record,
                                  double* input_data  );

extern void binio_fread_sp5(const int*   unit        ,
                            const int*   n1          ,
                            const int*   n2          ,
                            const int*   n3          ,
                            const int*   n4          ,
                            const int*   n5          ,
                            const long long*   record,
                                  float* input_data  );

extern void binio_fread_dp5(const int*    unit        ,
                            const int*    n1          ,
                            const int*    n2          ,
                            const int*    n3          ,
                            const int*    n4          ,
                            const int*    n5          ,
                            const long long*    record,
                                  double* input_data  );

extern void binio_fread_sp6(const int*   unit        ,
                            const int*   n1          ,
                            const int*   n2          ,
                            const int*   n3          ,
                            const int*   n4          ,
                            const int*   n5          ,
                            const int*   n6          ,
                            const long long*   record,
                                  float* input_data  );

extern void binio_fread_dp6(const int*    unit        ,
                            const int*    n1          ,
                            const int*    n2          ,
                            const int*    n3          ,
                            const int*    n4          ,
                            const int*    n5          ,
                            const int*    n6          ,
                            const long long*    record,
                                  double* input_data  );

extern void binio_fwrite_sp1(const int*   unit        ,
                             const int*   n1          ,
                             const long long*   record,
                                   float* output_data );

extern void binio_fwrite_dp1(const int*    unit        ,
                             const int*    n1          ,
                             const long long*    record,
                                   double* output_data );

extern void binio_fwrite_sp2(const int*   unit        ,
                             const int*   n1          ,
                             const int*   n2          ,
                             const long long*   record,
                                   float* output_data );

extern void binio_fwrite_dp2(const int*    unit        ,
                             const int*    n1          ,
                             const int*    n2          ,
                             const long long*    record,
                                   double* output_data );

extern void binio_fwrite_sp3(const int*   unit        ,
                             const int*   n1          ,
                             const int*   n2          ,
                             const int*   n3          ,
                             const long long*   record,
                                   float* output_data );

extern void binio_fwrite_dp3(const int*    unit        ,
                             const int*    n1          ,
                             const int*    n2          ,
                             const int*    n3          ,
                             const long long*    record,
                                   double* output_data );

extern void binio_fwrite_sp4(const int*   unit        ,
                             const int*   n1          ,
                             const int*   n2          ,
                             const int*   n3          ,
                             const int*   n4          ,
                             const long long*   record,
                                   float* output_data );

extern void binio_fwrite_dp4(const int*    unit        ,
                             const int*    n1          ,
                             const int*    n2          ,
                             const int*    n3          ,
                             const int*    n4          ,
                             const long long*    record,
                                   double* output_data );

extern void binio_fwrite_sp5(const int*   unit        ,
                             const int*   n1          ,
                             const int*   n2          ,
                             const int*   n3          ,
                             const int*   n4          ,
                             const int*   n5          ,
                             const long long*   record,
                                   float* output_data );

extern void binio_fwrite_dp5(const int*    unit        ,
                             const int*    n1          ,
                             const int*    n2          ,
                             const int*    n3          ,
                             const int*    n4          ,
                             const int*    n5          ,
                             const long long*    record,
                                   double* output_data );

extern void binio_fwrite_sp6(const int*   unit        ,
                             const int*   n1          ,
                             const int*   n2          ,
                             const int*   n3          ,
                             const int*   n4          ,
                             const int*   n5          ,
                             const int*   n6          ,
                             const long long*   record,
                                   float* output_data );

extern void binio_fwrite_dp6(const int*    unit        ,
                             const int*    n1          ,
                             const int*    n2          ,
                             const int*    n3          ,
                             const int*    n4          ,
                             const int*    n5          ,
                             const int*    n6          ,
                             const long long*    record,
                                   double* output_data );


