extern void binio_fopen(      int*  unit   ,
                        const char* file   ,
                        const char* action ,
                        const int*  recl   ,
                        const char* endian );


extern void binio_fclose(const int* unit);


extern void binio_fread_sp1(const int*   unit      ,
                            const int*   nx        ,
                            const int*   record    ,
                                  float* input_data);

extern void binio_fread_dp1(const int*    unit      ,
                            const int*    nx        ,
                            const int*    record    ,
                                  double* input_data);

extern void binio_fread_sp2(const int*   unit      ,
                            const int*   nx        ,
                            const int*   ny        ,
                            const int*   record    ,
                                  float* input_data);

extern void binio_fread_dp2(const int*    unit      ,
                            const int*    nx        ,
                            const int*    ny        ,
                            const int*    record    ,
                                  double* input_data);

extern void binio_fread_sp3(const int*   unit      ,
                            const int*   nx        ,
                            const int*   ny        ,
                            const int*   nz        ,
                            const int*   record    ,
                                  float* input_data);

extern void binio_fread_dp3(const int*    unit      ,
                            const int*    nx        ,
                            const int*    ny        ,
                            const int*    nz        ,
                            const int*    record    ,
                                  double* input_data);

extern void binio_fwrite_sp1(const int*   unit       ,
                             const int*   nx         ,
                             const int*   record     ,
                                   float* output_data);

extern void binio_fwrite_dp1(const int*    unit       ,
                             const int*    nx         ,
                             const int*    record     ,
                                   double* output_data);

extern void binio_fwrite_sp2(const int*   unit       ,
                             const int*   nx         ,
                             const int*   ny         ,
                             const int*   record     ,
                                   float* output_data);

extern void binio_fwrite_dp2(const int*    unit       ,
                             const int*    nx         ,
                             const int*    ny         ,
                             const int*    record     ,
                                   double* output_data);

extern void binio_fwrite_sp3(const int*   unit       ,
                             const int*   nx         ,
                             const int*   ny         ,
                             const int*   nz         ,
                             const int*   record     ,
                                   float* output_data);

extern void binio_fwrite_dp3(const int*    unit       ,
                             const int*    nx         ,
                             const int*    ny         ,
                             const int*    nz         ,
                             const int*    record     ,
                                   double* output_data);


